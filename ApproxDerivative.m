function limit = ApproxDerivative(f, t0, y0, t1, y1)
    h = t1 - t0;
    limit = (f(t1, y1) - f(t0, y0) / h);
end