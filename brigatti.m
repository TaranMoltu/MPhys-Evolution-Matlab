%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% brigatti.m
% Author: M. Williams 11/10/12
% Attempts to draw a graph of N(x) vs x as in the paper by Brigatti et al
% hence the name.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; %Let's start with a fresh slate

[FileName,PathName,FilterIndex] = uigetfile('*.dat');
filename = fullfile(PathName, FileName);
datamatrix = csvread(filename);
[rows, cols] = size(datamatrix); %rows is number of rows etc

buckets = input('How many buckets would you like to use? ');
bucketsize = (2*pi)/buckets;

bucketmax(1)= (-1*pi)+bucketsize;
for n=2:buckets
   bucketmax(n) = bucketmax(n-1)+bucketsize;
end

%Count
bucketmatrix = zeros(buckets+1,rows);

for i=1:rows
    for j=1:cols
        if datamatrix(i,j)~=0
            bucket = floor((datamatrix(i,j)+pi)/bucketsize)+1;
            bucketmatrix( bucket,i) = bucketmatrix( bucket,i)+1;
        end
    end
end

disp('sorted');

%Now plot for a single generation

plot(bucketmax, bucketmatrix(1:buckets,rows)) %last generation