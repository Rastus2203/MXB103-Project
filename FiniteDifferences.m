function resultList = FiniteDifferences(f, interval, intervalCount)
% Uses Finite Differences to perform numerical differentiation over
% the given function.
    resultList = zeros(1, intervalCount);
    for i = 2:intervalCount
        y0 = f(i);
        y1 = f(i+1);
        
        h = interval;
        limit = (y1 - y0) / h;
        resultList(i) = limit;
    end
end