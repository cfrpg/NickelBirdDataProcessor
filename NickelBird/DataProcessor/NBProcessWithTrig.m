function [data,freq,ps]=NBProcessWithTrig(file,cols,trig)
% [data,freq]=NBProcessWithTrig(file,cols,trig)
% Process file with trigger col,data will be divide into peroids by trigger
% column.
%
%	file:file handle
%	cols:data columns to be processed
%	trig:trigger column,not included in cols
%
%	data:average value of each processed column
%	freq:frequency of the data
%
% [data,freq,ps]=NBProcessWithTrig(file,cols,trig)
% Calculate average peroids for each column.
% 
%	ps:peroid data,each row contains one channel
%
	l=size(cols,2);
	data=zeros(1,l);	
	trigcol=file.data(:,trig);
	allpos=find(trigcol~=0);
	n=size(allpos,1);
	if n==0
		n=2;
		allpos=[1,max(size(trigcol))];
	end
	lens=diff(allpos);
	maxlen=max(lens);
	freq=1000/mean(lens);		
	ps=zeros(l,maxlen);
	for i=1:l
		data(i)=mean(file.data(allpos(1):allpos(n)-1,cols(i)));
		if nargout<3
			continue;
		end
		for j=1:n-1
			ps(i,1:lens(j))=ps(i,1:lens(j))+file.data(allpos(j):allpos(j+1)-1,cols(i))';
		end
	end
	if nargout==3
		ps=ps/(n-1);
	end
end
