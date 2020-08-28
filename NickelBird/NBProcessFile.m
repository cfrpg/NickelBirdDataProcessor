function [header,data,freq]=NBProcessFile(file,cols,trig,ref,p)
	header=file.colheaders(cols);
    l=size(header);
    l=l(2);
	data=zeros(1,l);
	freq=zeros(1,l);
	mincor=1
    %Process cols
	
    for i=1:l
		%[data(i) freq(i)]=NBProcess(file.data(:,cols(i)));
        if p~=0
            [cor,~,aver]=NBGetPeriod(file.data(:,cols(i)));
            data(i)=mean(aver);
            t=size(aver);
            freq(i)=1000/t(2);
			if cor<mincor
				mincor=cor;
			end
        else
            data(i)=mean(file.data(:,cols(i)));
            freq(i)=0;
        end
	end
	if mincor<0.25
		for i=1:l
			data(i)=mean(file.data(:,cols(i)));
            freq(i)=0;
		end
	end
end


