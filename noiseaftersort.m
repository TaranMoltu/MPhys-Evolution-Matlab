%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noiseaftersort.m
% Author: M. Williams 1/11/12
% This file replicates most of noiseplot.m but doesn't attempt to sort the
% data itself. Instead, the data is sorted into buckets by a C++ script
% called MPhys-evolution-datasort
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[FileName,PathName,FilterIndex] = uigetfile('*.dat');
file = fullfile(PathName, FileName);

bucketmatrix = csvread(file);
[rows, cols] = size(bucketmatrix); %rows is number of rows etc

bucketmatrix=rot90(bucketmatrix); %Correct the dimensions
bucketmatrix=flipud(bucketmatrix);

numberalive = max(bucketmatrix);
bignumberalive=zeros(cols,rows);

for i=1:cols
    bignumberalive(i,:)=numberalive;
end
bucketfractions = bucketmatrix./bignumberalive.*255;

%We now need to start graphing these colours
%ia=ones(200,200).*255;
output = uint8(bucketfractions);
[~, name, ~] = fileparts(FileName);
 imwrite(output, fullfile(PathName, [name '.png']), 'png');
% 
% [fractionrows, fractioncols] = size(bucketfractions);
% ia(1:fractionrows, 1:fractioncols) = bucketfractions;
% 
% imshow(ia(1:fractionrows, 1:fractioncols));
disp('End of program');