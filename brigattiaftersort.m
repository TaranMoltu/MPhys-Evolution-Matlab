%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% brigattiaftersort.m
% Author: M. Williams 1/11/12
% This file replicates most of brigatti.m but doesn't attempt to sort the
% data itself. Instead, the data is sorted into buckets by a C++ script
% called MPhys-evolution-datasort
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[FileName,PathName,FilterIndex] = uigetfile('*.dat*');
file = fullfile(PathName, FileName);


bucketmatrix = csvread(file);
[rows, cols] = size(bucketmatrix); %rows is number of rows etc

bucketmatrix=rot90(bucketmatrix); %Correct the dimensions
bucketmatrix=flipud(bucketmatrix);

bucketsize = (2*pi)/cols;
bucketmax(1)= (-1*pi)+bucketsize;

for n=2:cols
   bucketmax(n) = bucketmax(n-1)+bucketsize;
end

plot(bucketmax, bucketmatrix(1:cols,rows))