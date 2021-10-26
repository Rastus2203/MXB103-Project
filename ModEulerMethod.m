classdef ModEulerMethod
    properties
        func
        t0
        w0
        h
    end

    methods
        function obj = ModEulerMethod(f, t0, w0, h)
            obj.func = f;
            obj.t0 = t0;
            obj.w0 = w0;
            obj.h = h;
        end
        
        function result = Calculate(obj, t)            
            n = (t - obj.t0) / obj.h - obj.h ;
            if ((n < 0) || (floor(n) ~= n))
                %error('Invalid value "' + string(t) + '" for t');
            end
            
            
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
        
end

