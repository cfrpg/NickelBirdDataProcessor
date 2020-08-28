function NBPlotPeriods(ps)   
    figure(1);
    clf();
    hold on;
    len=size(ps);
    len=len(1);
    for i=1:len
        plot(ps(i,:));
    end
    figure(2);
    clf();
    hold on;
    plot(mean(ps));
end