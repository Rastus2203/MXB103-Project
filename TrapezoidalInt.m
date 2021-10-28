function [result] = TrapezoidalInt(f, a, b, h)
% Performs numerical integration through use of the trapezoidal rule.
    range = b - a;
    N = range / h;
    
    sum  = 0.5 * f(1) * f(N+1);
    for i = 2:N
        sum = sum + f(i);
    end 
    result = sum * h;

end

