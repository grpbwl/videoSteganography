% Reading the information and storing it to get rid of the 4 MSB
dave = imread('data\daveg01.bmp');
dave = imresize( dave , [128 128]);
seed = imresize( dave , [32 32]);

for r=1:32
    for c=1:32
        seed(r,c)
        dec2bin(seed(r,c),8)
    end
end