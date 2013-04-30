%readerandwriter.m
%Reads in the data, takes generation 1 and x where x is the final
%generation, maps and plots each using a plot already hopefully defined
%using xbitmapping.m then smiles as it's done. 
%M. Williams 14/2/2013 (<3)

% Housekeeping: read in the data in the traditional method
startFolder = pwd;
[FileName,PathName,FilterIndex] = uigetfile('*.dat');
filename = fullfile(PathName, FileName);
cd(PathName);
genomematrix = csvread(filename);
[generations, cols] = size(genomematrix);
x = 8; %x is the number of dimensions

%-==========================================
EntitiesPerGeneration=zeros(generations,1);
fid = fopen(filename);
literal=',';
tline = fgetl(fid);
i=1;
while ischar(tline)
   matches = strfind(tline, literal);
   EntitiesPerGeneration(i)=length(matches)+1;
   tline = fgetl(fid);
   i=i+1;
end
clear i;
fclose(fid);

%============================

%Preallocate the counter for speed
counter = zeros(2^x, generations); %Go down to work out how many there are at a generation across

%Next, split the data so that our old pal tsne.m can read it sensibly.
%Since the numbers were read in as numbers rather than strings, we need to
%pad them as strings with 0000 depending how many dimensions we have.
binary_value=zeros(cols,1);

density = zeros(2^x+1,generations);
colormap = ones(2^x+1,3);%the colours for a single generation
    
for i=1:10:generations %Takes every 10th generation instead of all generations
    for j=1:EntitiesPerGeneration(i)
        if numel(num2str(genomematrix(i,j)))<x %Assumes 8D array. Better practice would be to work out the size of the largest value or ask for it
           %Code to pad with zeroes goes here 
           padsize = x - numel(num2str(genomematrix(i,j))); %Assumes 8 again
           pad=zeros([1,padsize]);
           %Convert pad to string and remove spaces
           pad=num2str(pad);
           pad=regexprep(pad,'[^\w'']',''); %Use regexp from http://www.mathworks.co.uk/matlabcentral/newsreader/view_thread/158554 to remove space
           temp= [pad, num2str(genomematrix(i,j))];
        else
            temp= num2str(genomematrix(i,j));
        end
        
        binary_value(j) = bin2dec(temp);
        counter((binary_value(j)+1), i) = counter((binary_value(j)+1), i)+1;%make a count of how many there are in each generation
    end
    
    [~, cols_gens] = size(binary_value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The lines below should be uncommented to use a pre-prepared mapping.
   
    for k=1:EntitiesPerGeneration(i)
        %First map the datas
        mapped_data(k,1) = mapped_Xbit(binary_value(k)+1,1);
        mapped_data(k,2) = mapped_Xbit(binary_value(k)+1,2);

        %Now convert this to a density and hex code...
        density((binary_value(k)+1), i) = counter((binary_value(k)+1),i)./max(counter(:,i));
        colormap(binary_value(k)+1,:)=density((binary_value(k)+1),i);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %Plot scatter map of these
    scatter(mapped_Xbit(:,1), mapped_Xbit(:,2),20, colormap,'filled');
    figurename = ['Generation ', num2str(i)];
    annotation('textbox', [.5, .75, .1, .1], 'string', figurename);
    annotation('textbox', [.25, .75, .1, .1], 'string', num2str(EntitiesPerGeneration(i)));
    axis equal;
    M(i)=getframe;
    disp(i);
    clf; %Clears the frame of all data allowing us to remove annotations
   %print('-dtiff', figurename); %Prints the generation to a file called generation_x.tiff
end

% Now plot some other useful data. First, entities per generation vs
% generations number

figure(2);
plot(1:10:generations, EntitiesPerGeneration(1:10:generations));
figure_2 = strcat('entities ', FileName, '.tiff');
print('-dtiff', figure_2);
%We now want to work out how many clusters there are in each generation.
%For simplicity, we assume a cluster has greater than 10 organisms in it.
numberOfClusters = zeros(generations,1);
for i=1:10:generations %Takes every 10th generation instead of all generations
    for j=1:2^x %Goes down counter to last possible space
        if counter(j,i) > 0
            numberOfClusters(i) = numberOfClusters(i)+1;
        end
    end
end
figure(3);
plot(1:10:generations, numberOfClusters(1:10:generations), '-.r');
figure_3 = strcat('clusters ', FileName, '.tiff');
print('-dtiff', figure_3);

cd(startFolder); %Return from whence we started


