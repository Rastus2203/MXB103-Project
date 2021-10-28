classdef Lagrange
    properties
        n
        x
        y
    end
    
    methods
        function obj = Lagrange(x, y)
            assert(size(x, 2) == size(y, 2));
            
            tmp = size(x);
            obj.n = tmp(2);
            obj.x = x;
            obj.y = y;
        end
        
        function result = Calculate(obj, x)
            
            sum = 0;
            for i = 1:obj.n
                product = obj.y(i);
                for j = 1:obj.n
                    if (i ~= j)
                        product = product * (x - obj.x(j)) / (obj.x(i) - obj.x(j));
                    end
                end
                
                sum = sum + product;
            end
            
            result = sum;
        end
    end
    
end