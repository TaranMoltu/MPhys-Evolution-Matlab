%BinaryGenome.m
%The beginnings of reading and making use of the Binary Genome. Not
%optimised or pretty but will try for frequency counting eventually.

%TODO: Flag death by looking for five 0's in a row then cutting to the next
%line.
tic;
[FileName,PathName,FilterIndex] = uigetfile('*.dat');
filename = fullfile(PathName, FileName);
genomematrix = csvread(filename);
%In order to hash using MATLABs built in bin2dec() function, the
%genomematrix needs to be a string. Hence, convert using num2str

[rows, cols] = size(genomematrix); %rows is number of rows etc

%We also need to ensure the length of every string is 8 by padding with
%zeroes

% for i=1:rows
%     for j=1:cols
%         if numel(genomematrix(i,j))~=8
%             %First, convert to string since this has to be done in the loop
%             genomematrixstr = num2str(genomematrix(i,j));
%             genomematrix(i,j) = genomematrixstr(1,1);
%             % Work out how many zeroes we need to pad with
%             padsize = 8 - numel(genomematrix(i,j));
%             pad=zeros([1,4]);
%             %Convert pad to string and remove spaces
%             pad=num2str(pad);
%             pad=regexprep(pad,'[^\w'']',''); %Use regexp from http://www.mathworks.co.uk/matlabcentral/newsreader/view_thread/158554 to remove space
%             
%             %Now concatenate the string and we have an 8 digit string for
%             %use with Hamming distance
%             
%             combined = [pad, genomematrix(i,j)];
%             genomematrix(i,j) = combined(1,1);
%             
%         end
%     end
% end
decimalvalue = zeros(cols,rows);
frequencycounter = zeros(rows,256); %256 possible values of genomes after hashing
numberalive = zeros(rows,256);
for i=1:rows
    
    for j=1:cols
        if j>1 
            oldvalue = decimalvalue;
        end
        decimalvalue = bin2dec(num2str(genomematrix(i,j)));
        genomematrix(i,j) = decimalvalue;
        %Five zeroes == end of row OR we've reached the end of the row
        if decimalvalue==0 || j==rows
            if (genomematrix(i,j+1) == 0 && genomematrix(i,j+2) == 0 && genomematrix(i,j+3) == 0 && genomematrix(i,j+4) == 0) || j==rows
                numberalive(i,:) = j-1;
                break;
            end
        end
        frequencycounter(i,decimalvalue+1) = frequencycounter(i, decimalvalue+1)+1;
        str = ['(i, j) is (', num2str(i), ', ', num2str(j), ')'];
        disp(str);
    end
    
end



fractions = (frequencycounter./numberalive);
%Calculate list of maxima and redefine cols and rows to reflect size of
%fractions
maximaRows = max(fractions,[],2);
[rows, cols] = size(fractions); 
for i = 1:rows
    for j=1:cols
        fractions(i,j) = fractions(i,j)/maximaRows(i);
    end
end

output = uint8(floor(fractions.*255));
[~, name, ~] = fileparts(FileName);
imwrite(output, fullfile(PathName, [name '.png']), 'png');

toc;