function [result] = TrapezoidalInt(f, a, b, h)
    result = 0;
    
    range = b - a;
    N = range / h;
    
    sum  = 0.5 * f(1) * f(N+1);
    for i = 2:N
        sum = sum + f(i);
    end 
    result = sum * h;

end

