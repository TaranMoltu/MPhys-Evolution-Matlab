%xbitmapping.m
%Firstly, generates the set of x-bit binary number from 0 to 2^x. Then maps
%this set using t-SNE. We can then use this map to compute the mapping for
%a real set

x=8; %Sets the number of bits to be used.

max = 2^x; %Hence, the highest decimal number is 2^8. The minimum is of course 0
%data= zeros(max,1);
for n=0:max
    tmp = dec2bin(n,x);
    disp(n);
    for m=1:x
        splitdata(n+1,m) = tmp(m); %Note: MATLAB starts from index 1, not 0 so must add 1 here or be out of bounds. Remember to subtract this later.
        splittext(n+1,m) = str2num(splitdata(n+1,m)); %Expanded out
    end
end
clear max;
clear m;
clear n;
clear splitdata;
clear x;
%Now we need to compute a mapping. The first line uses t-sne, the second
%uses sammon. Uncomment as preferred.

%mapped_Xbit = tsne(splittext, [], 2, x, 30); %Maps the x-bit variable splittext to 2D and stores as mapped_Xbit
mapped_Xbit = compute_mapping(splittext, 'PCA', 2);
%TODO: might be a nice idea to do several mappings and work out which is
%best. Another time maybe