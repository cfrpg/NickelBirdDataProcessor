function [header,data,freq,vars,ps]=NBLoadFile(path,cols,p)
% [header,data,freq]=NBLoadFile(path,cols,p)
% Load and process a result file.
%
%	path:File path
%	cols:columns to be processed
%	p:is periodic data flag
%
%	header:processed data header
%	data:average value of each processed column
%	freq:frequency of the data
%
% [header,data,freq,ps]=NBLoadFile(path,cols,p)
% Calculate average peroids for each column.
% 
%	ps:peroid data,each row contains one channel

    %Load csv file
    file=importdata(path);  
    len=size(cols,2);
	ref=0;
	trig=0;
	
	%check input arg type
	argtype=class(cols);
	if strcmp(argtype,'cell')
		%translate header name to col num
		allheaders=file.colheaders;
		n=size(allheaders,2);
		tcol=zeros(1,len);
		for i=1:len
			flag=0;
			str=cols{i};
			if str(1)=='*'
				%trig col
				flag=1;
				str=str(2:end);
			else
				if str(1)=='#'
					%ref col
					flag=2;
					str=str(2:end);
				end
			end
			for j=1:n
				if strcmp(str,allheaders{j})
					tcol(i)=j;
					break;
				end
			end
			if flag==1
				tcol(i)=-tcol(i);
			end
			if flag==2
				tcol(i)=tcol(i)+10000;
			end
		end
		cols=tcol;
	end
	%translate col id into realcol
	realcol=[];
	for i=1:len
		if cols(i)<0
			trig=-cols(i);
			continue;
		end
		if cols(i)>10000
			cols(i)=cols(i)-10000;
			ref=cols(i);
		end
		realcol=[realcol,cols(i)];
	end
	%get headers
	header=file.colheaders(realcol);
	%process data
	if nargout<=5
		ps=0;
		if trig>0
			[data,freq,vars]=NBProcessWithTrig(file,realcol,trig);
		elseif ref>0
			[data,freq,vars]=NBProcessWithRef(file,realcol,ref);
		else
			[data,freq,vars]=NBProcessWithNothing(file,realcol,p);
		end
	else
		if trig>0
			[data,freq,vars,ps]=NBProcessWithTrig(file,realcol,trig);
		elseif ref>0
			[data,freq,vars,ps]=NBProcessWithRef(file,realcol,ref);
		else
			[data,freq,vars,ps]=NBProcessWithNothing(file,realcol,p);
		end
	end	
end