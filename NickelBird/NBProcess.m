function [ps val Freq]=NBProcess(v)
    [~,ps,aver]=NBGetPeriod(v);
    NBPlotPeriods(ps);
    val=mean(aver)
    Freq=size(aver);
    Freq=1000/Freq(2)
end