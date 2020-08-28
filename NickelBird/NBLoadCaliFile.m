function [headers,alpha,data]=NBLoadCaliFile(path)
	file=importdata(path);
	%dcnt=size(file.colheaders,2);
	headers=file.colheaders(2:end);
	alpha=file.data(:,1);
	data=file.data(:,2:end);	
end