classdef ModEulerMethod < handle
    properties
        func
        t0
        w0
        h
        
        wList
        tList
        i
    end

    methods
        % Constructor for ModEulerMethod
        % Returns obj
        % Func f   : Function to approximate. Takes 2 floats and returns a
        %   float
        % Float t0 : Intial value for t.
        % Float w0 : Intial value for w.
        % Float h  : Step size
        function obj = ModEulerMethod(f, t0, w0, h)
            obj.func = f;
            obj.t0 = t0;
            obj.w0 = w0;
            obj.h = h;
            
            obj.tList = [obj.t0];
            obj.wList = [obj.w0];
            obj.i = 1;
        end
        
                
        % Calculates a single step past the current state and returns the
        %   values.
        % Allows for values to be manipulated between every iteration of
        % the method. Calculates the next [t, w]
        % Returns [tNew, wNew]
        function result = CalcNext(obj)
            tOld = obj.tList(obj.i);
            wOld = obj.wList(obj.i);
            
            k1 = obj.h * obj.func(tOld, wOld);
            tNew = tOld + obj.h;
            k2 = obj.h * obj.func(tNew, wOld + k1);
            wNew = wOld + 0.5 * (k1 + k2);
            
            result = [tNew, wNew];
        end
        
        % Resets the values used for single step calculations
        function resetCalc(obj)
            obj.wList = [obj.w0];
            obj.tList = [obj.t0];
            obj.i = 1;
        end
        
        
        % Adds new t, w values for single step calculations
        % Float tNew : The new value for t
        % Float wNew : The new value for w
        function AddNew(obj, tNew, wNew)
            obj.i = obj.i + 1;
            obj.tList(obj.i) = tNew;
            obj.wList(obj.i) = wNew;
            
        end
        
        
        % Gets the last added t/w values
        % Optional Int Val : If supplied, this refers to the index of the
        %   value required. 1:t, 2:w
        % Default Return [t, w]
        % If val specified, will return either t or w
        function result = LastVal(obj, val)
            t = obj.tList(obj.i);
            w = obj.wList(obj.i);
            
            if exist('val', 'var')
                if (val == 1)
                    result = t;
                elseif (vale == 2)
                    result = w;
                else
                    error("Supplied value is not a valid index");
                end
            else
                result = [t, w];
            end
            
        end

        
        
        % Calculates the approximate value for our function up to t
        % Returns the value of w at t
        % Float t : Value of t to find w for.
        function result = CalcT(obj, t)            
            tOld = obj.t0;
            wOld = obj.w0;

            while tOld <= t - obj.h
                k1 = obj.h * obj.func(tOld, wOld);
                tNew = tOld + obj.h;
                k2 = obj.h * obj.func(tNew, wOld + k1);
                wNew = wOld + 0.5 * (k1 + k2);

                tOld = tNew;
                wOld = wNew; 
            end
            result = wOld;
        end
    end
    
    methods (Static)
        % Takes two ModEulerMethod objects and a number of iterations.
        % This method does calculations on two functions that each take the
        % same two variables in opposite orders, and they each produce one
        % of those variables.
        % Each function produces the 'w' component of themselves, and takes
        % the 'w' component of the other function.
        function result = CalcDependant(eulerA, eulerB, maxIter)
            assert(eulerA.t0 == eulerB.t0);
            assert(eulerA.w0 == eulerB.w0);
            assert(eulerA.h  == eulerB.h);
            
            eulerA.resetCalc();
            eulerB.resetCalc();
            
            iter = 0;
            while (iter < maxIter)
                AResult = eulerA.CalcNext();
                BResult = eulerB.CalcNext();
                
                newA = AResult(2);
                newB = BResult(2);
                
                eulerA.AddNew(newB, newA);
                eulerB.AddNew(newA, newB);
                                
                iter = iter + 1;                
            end
            result = [eulerA.wList; eulerB.wList];
        end
    end        
end

