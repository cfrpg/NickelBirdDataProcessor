function NBAuto(dirPath,cols,p,alpha,transcol,califile)
% NBAuto(dirPath,cols,p,alpha,transcol,califile)
% Auto data processor.
%
%	dirpath:file directory
%	cols:columns to be processed,header name or id list
%	p:is periodic data flag
%
% [optional]Frame transform,use alpha tag to transform body frame to wind frame.
%	alpha:alpha tag id
%	transcol:2*n matrix,each row contains 2 column id of OUTPUT data:x_id &
%	z_id
% [optional]Calibration,must use with transform
%	califile:calibration file
%
	%get file list
	fileList=dir([dirPath,'/*.csv']);
	fcnt=size(fileList,1);
	
	%creat result file
	fout=fopen(fullfile(dirPath,'res.csv'),'w+');
	dcnt=max(size(cols));
	tagnames=['Tag1';'Tag2';'Tag3';'Tag4';'Tag5';'Tag6';'Freq'];
	flag=0;
	
	if nargin==6
		%load cali file;
		califile=importdata(califile);	
		caliheaders=califile.colheaders(2:end);
		calialpha=califile.data(:,1);
		calidata=califile.data(:,2:end);
		calicnt=size(calidata,2);
	end
	
	for i=1:fcnt		
		[~,fn,ext]=fileparts(fileList(i).name);
		fprintf('process %d of %d:%s\n',i,fcnt,fn);
		%check filename hint file		
		if strcmp(ext,'.csv')==0
			disp('not csv,skip.');
			continue;
		end
		if strcmp(fn(1:3),'res')
			disp('res file,skip.');
			continue;
		end        
        [h,d,f]=NBLoadFile(fullfile(fileList(i).folder,fileList(i).name),cols,p);
		dcnt=max(size(h));
		%output header row
		if flag==0
			for j=1:7
				fprintf(fout,'%s,',tagnames(j,:));
			end			
			for j=1:dcnt
				fprintf(fout,'%s,',h{j});
			end			
			if nargin>=5
				%transform header
				tn=size(transcol,1);
				for j=1:tn
					fprintf(fout,'%s,%s,',[h{transcol(j,1)},'_w'],[h{transcol(j,2)},'_w']);
				end
			end
			fprintf(fout,'\n');
			flag=1;			
		end
		tags=strsplit(fn,'_');
		tagCnt=size(tags,2);
		
		%output res
		%fprintf(fout,'%s,',fileList(i).name);
		for j=2:7
			if j>tagCnt
				fprintf(fout,',');
			else
				fprintf(fout,'%s,',tags{j});
			end
		end		
		fprintf(fout,'%f,',f);
		if nargin==6
			%cali
			a=str2double(tags{alpha+1});
			for j=1:dcnt
				for k=1:calicnt
					if strcmp(h{j},caliheaders{k})
						d(j)=d(j)-interp1(calialpha,calidata(:,k),a,'linear','extrap');
						break;
					end
				end
			end
		end
		for j=1:dcnt
			fprintf(fout,'%f,',d(j));
		end
		if nargin>=5
				%transform data
				a=str2double(tags{alpha+1});
				a=deg2rad(a);
				tn=size(transcol,1);
				ca=cos(a);
				sa=sin(a);
				for j=1:tn
					xb=d(transcol(j,1));
					zb=d(transcol(j,2));
					xw=xb*ca+zb*sa;
					zw=-xb*sa+zb*ca;
					fprintf(fout,'%f,%f,',xw,zw);
				end
			end
		fprintf(fout,'\n');
	end
	fclose(fout);
end
