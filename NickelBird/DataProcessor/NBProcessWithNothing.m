function [data,freq,ps]=NBProcessWithNothing(file,cols,p)
% [data,freq]=NBProcessWithNothing(file,cols,p)
% Process file with no assistance
%
%	file:file handle
%	cols:data columns to be processed
%	p:peroidic data flag
%
%	data:average value of each processed column
%	freq:frequency of the data
%
% [data,freq,ps]=NBProcessWithNothing(file,cols,p)
% Calculate average peroids for each column.
% 
%	ps:peroid data,each row contains one channel
%
	header=file.colheaders(cols);
    l=size(header);
    l=l(2);
	data=zeros(1,l);
	freq=zeros(1,l);
	mincor=1;
	arr={};
    %Process cols	
	for i=1:l
		%[data(i) freq(i)]=NBProcess(file.data(:,cols(i)));
		if p~=0
            [cor,tps,aver]=NBGetPeriod(file.data(:,cols(i)));
			arr{i}=mean(tps);
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
	else
		if nargout==3
			maxlen=0;
			for i=1:l
				maxlen=max(maxlen,max(size(arr{i})));
			end
			ps=zeros(l,maxlen);
			for i=1:l
				len=max(size(arr{i}));
				ps(i,1:len)=arr{i};
			end
		end
	end
	freq=getFreq(freq,0.05);
end


function res=getFreq(data,threhold)
	res=data(1);
	cnt=1;
	n=max(size(data));
	for i=2:n
		if abs(res-data(i))>threhold
			cnt=cnt-1;
			if cnt<=0
				res=data(i);
				cnt=1;
			end
		else
			cnt=cnt+1;
		end
	end
end