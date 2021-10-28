function result = SecantRoot(f, x0, x1, maxIter)
% Uses the Secant Method to numerically find the root of the given
% function.
    for i = 1:maxIter
        x2 = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0));
        x0 = x1;
        x1 = x2;
    end
    
    result = x2;
end