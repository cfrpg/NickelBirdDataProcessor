function NBProcessCaliFile(dirPath,cols,alpha)
% NBProcessCaliFile(dirPath,cols,alpha)
% Generate calibration file (rescali.csv) from data set.
%
%	dirPath:file directory
%	cols:columns to be processed,header or id list
%	alpha:alpha tag id
%
	%get file list
	fileList=dir([dirPath,'/*.csv']);
	fcnt=size(fileList,1);
	
	%creat result file
	fout=fopen(fullfile(dirPath,'rescali.csv'),'w+');
	dcnt=max(size(cols));	
	flag=0;	
	for i=1:fcnt		
		[~,fn,ext]=fileparts(fileList(i).name);
		fprintf('process %d of %d:%s\n',i,fcnt,fn);
		%check filename hint file
		%bad chinese support
		if strcmp(ext,'.csv')==0
			disp('not csv,skip.');
			continue;
		end
		if strcmp(fn(1:3),'res')
			disp('res file,skip.');
			continue;
		end        
        [h,d,f]=NBLoadFile(fullfile(fileList(i).folder,fileList(i).name),cols,0);
		dcnt=max(size(h));
		%output header row
		if flag==0			
			fprintf(fout,'alpha,');				
			for j=1:dcnt
				fprintf(fout,'%s,',h{j});
			end			
			fprintf(fout,'\n');
			flag=1;			
		end
		tags=strsplit(fn,'_');
		
		%output res
		%fprintf(fout,'%s,',fileList(i).name);
		fprintf(fout,'%s,',tags{alpha+1});		
		for j=1:dcnt
			fprintf(fout,'%f,',d(j));
		end		
		fprintf(fout,'\n');
	end
	fclose(fout);
end