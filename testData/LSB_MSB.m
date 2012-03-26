% Reading the information and storing it to get rid of the 4 MSB
dave = imread('data\daveg01.bmp');
dave = imresize( dave , [128 128]);
seed = imresize( dave , [32 32]);
shiftAmount = 3;

figure;imshow(seed)

for r=1:32
    for c=1:32
        bit = bitshift(seed(r,c),-shiftAmount);
        bit = bitshift(bit,shiftAmount);
        seed(r,c) = bit;
%         seed(r,c)
%         dec2bin(seed(r,c),8)
    end
end

figure;imshow(seed)