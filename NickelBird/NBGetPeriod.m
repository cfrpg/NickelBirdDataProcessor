function [cor,ps,aver] = NBGetPeriod(v)
    ps=[];
    len=size(v);
    len=len(1);
    cnt=1;
    pl=0;
    %find first period
    c=autocorr(v,len-1);
    tmp=find(c==min(c));
    tmps=size(tmp);
    if isempty(tmp)
        ps=v;
        aver=mean(v);
		cor=0;
        return;
    end
    minpos=tmp(1);
    tmp=find(c==max(c(minpos:end)));
	%sprintf(',%f,',c(tmp(1)));
	%disp(c(tmp(1)))
	cor=c(tmp(1));
    tmp2=find(tmp>minpos);
    pl=tmp(tmp2(1));   
    ps(1,pl)=0;   
    ps(cnt,1:pl)=v(1:pl);
    cnt=cnt+1;
    v=v(pl:end);
    len=size(v);
    len=len(1);    
    last=ps(1,:);
    dl=int32(pl/4);
    while(len>pl)
        [c,lag]=xcorr(v,last);
        mid=find(lag==0);
        maxpos=find(c==max(c(mid-dl:mid+dl)));
        lag=lag(maxpos(1));
        if lag<0
            ps(cnt,1-lag:pl)=v(1:pl+lag);
            ps(cnt,1:-lag)=ps(cnt-1,end+lag+1:end);
            v=v(pl+lag+1:end);
        else
            if lag+pl<=len
                ps(cnt,1:pl)=v(1+lag:lag+pl);
                v=v(lag+pl+1:end);
            else
                v=v(end);
            end
        end       
        %last=ps(cnt,:);
        cnt=cnt+1;
        len=size(v);
        len=len(1);    
    end
    aver=mean(ps);
end