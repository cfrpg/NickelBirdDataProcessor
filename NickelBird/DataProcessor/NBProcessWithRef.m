function [data,freq,vars,ps]=NBProcessWithRef(file,cols,ref)
% [data,freq]=NBProcessWithRef(file,cols,trig)
% Process file woth reference col,data will be divide into same peroids as
% reference column.
%
%	file:file handle
%	cols:data columns to be processed
%	ref:reference column,included in cols
%
%	data:average value of each processed column
%	freq:frequency of the data
%
% [data,freq,ps]=NBProcessWithRef(file,cols,trig)
% Calculate average peroids for each column.
% 
%	ps:peroid data,each row contains one channel
%
	l=size(cols,2);
	data=zeros(1,l);	
	refcol=file.data(:,cols(ref));
	
end