function out = read_rsm(filename)
%READ_RSM Summary of this function goes here
%   Detailed explanation goes here

    %open file
    if ~exist('filename', 'var')
        error(['''' filename ''' does not exist']); end

    % Open file
    fclose all;
    fid = fopen(filename);
    if fid < 3; error 'Error while opening file'; end
    
    dataLineCounter = 0;
    nKeyWords = 0;
    flagDataBlock = false;
    nBlockCounter = 0;
    tline = fgetl(fid);
    
    while ~feof(fid)    %end of file
%        disp(tline)
        % analysis the line
        
        if strlength(tline)<5
            if ~flagDataBlock
               % do nothing
            else
               %data block complete
               flagDataBlock = false;
            end            
        else
           if ~flagDataBlock && contains(tline, 'SUMMARY')
               % 'SUMMARY' is the start of one data block
               flagDataBlock = true;
               nBlockCounter = nBlockCounter+1;
                
               %read until next empty line
               tline = fgetl(fid);
               keywords = regexp(tline, '\w*', 'match');
               if nKeyWords == 0
                   %repeat keywords
                   out.keyword = keywords;
                   nKeyWords = length(out.keyword);
                   
                   tline = fgetl(fid);
                   tline = fgetl(fid);
                   tline = fgetl(fid);
                   tline = fgetl(fid);

                   %%%%%%%%%%%%%%%
                   % add data into blocks
                   tline = fgetl(fid);
                   tempFormat = ['%s', repmat('%f' , 1 , nKeyWords - 1)];
                   while strlength(tline) > 5
                       if dataLineCounter == 0
                           out.Data = textscan(tline, tempFormat);                       
                       else
                            out.Data = [out.Data; textscan(tline, tempFormat)];
                       end
                       dataLineCounter = dataLineCounter + 1;
                       tline = fgetl(fid);
                       if tline == -1
                           break;
                       end
                   end     
                   out.dataLineCounter = dataLineCounter;
                   flagDataBlock = false; %block complete, tline -> empty line
               else
                   nAddtionalKeywords = length(keywords); %new keywords number
                   out.keyword = [out.keyword , keywords{2:nAddtionalKeywords}];
                   nKeyWords = nKeyWords + nAddtionalKeywords -1;
                   out.KeywordCount = nKeyWords;
                   
                  %%%%%%%%%%%%%%%%%
                  % add data append to the blocks
                   tline = fgetl(fid);
                   tline = fgetl(fid);
                   tline = fgetl(fid);
                   %%%%%%%%%%%%%%%
                   % add data into blocks
                   tline = fgetl(fid);
                   tempFormat = ['%s', repmat('%f' , 1 , nAddtionalKeywords - 1)];
                   i = 0;
                   while i < dataLineCounter
                       i = i+1;
                       if i == 1
                           newData = textscan(tline, tempFormat);
                       else
                            newData = [newData; textscan(tline, tempFormat)];
                       end
                       tline = fgetl(fid);
                   end         
                   newData(:,1) = [];       %delete the repeat first column
                   out.Data = [out.Data newData];
               end            
           else
               %not empty line
           end
               
        end
        tline = fgetl(fid);   %to next line               
    end
    
    fclose(fid);
end

