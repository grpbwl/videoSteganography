% Reading the information and storing it to get rid of the 4 MSB
dave = imread('data\daveg01.bmp');
dave = imresize( dave , [128 128]);
seed = imresize( dave , [32 32]);
shiftAmount = 3;

a = uint8(13);
s = uint8(10);

% Erase the bits at the end, not necessary dummy
% a = bitshift(a,-shiftAmount);
% a = bitshift(a,shiftAmount);

% Insert shiftAmount MSB into LSB
msb = 4;
for lsb=1:shiftAmount
    a = bitset(a,lsb,bitget(s,msb));
    msb = msb - 1;
end

disp(a)
disp(s)

% figure;imshow(seed)

% for r=1:32
%     for c=1:32
%         bit = bitshift(seed(r,c),-shiftAmount);
%         bit = bitshift(bit,shiftAmount);
%         seed(r,c) = bit;
%         seed(r,c)
%         dec2bin(seed(r,c),8)
%     end
% end

% figure;imshow(seed)