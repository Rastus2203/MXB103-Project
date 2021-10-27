function [outputArg1,outputArg2] = graphHeightTime(results)
    yList = H - results(1,:);
    x = linspace(0,timeSeconds, intervalCount + 1);

    figure;
    plot(x, yList);
    axis([0, timeSeconds, 20, H]);



end

