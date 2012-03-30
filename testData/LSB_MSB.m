% Reading the information and storing it to get rid of the 4 MSB
% dave = imread('data\daveg01.bmp');
dave = imread('data/daveg01.bmp');
dave = imresize( dave , [128 128]);
seed = imresize( dave , [32 32]);
depth = 8;

% figure;imshow(dave)

daveOrig = dave;
seedClone = size(seed);


% Iterate in increments of 8's because we are doing 8x8 blocks
for r=1:8:size(seed,1)
    for c=1:8:size(seed,2)
        
        % Attempt to skip half of the values in the seed.
        % TODO: This probably goes somewehere else.
%         if (r + c == 9) % 9 is related to the MB size
%             continue;
%         end
        
        % MacroBlock
        mb = dave(r:(r+7),c:(c+7));% - 128;
        
        % TODO: Consider changing the type to single.
        % mb = single(mb);
        
        % Apply DCT to the block before seeding
        seeded_block = dct2(mb);
        
        % For every block embed part of the image.
        seeded_block = embed(seeded_block, seed(r:(r+7),c:(c+7)),depth );
        
        % Apply I-DCT to the block before applying back to the image
        seeded_block = idct2(seeded_block);% + 128;
        
        % Apply seed to image
        dave(r:(r+7),c:(c+7)) = seeded_block;
        
        % Retrieve
        seedClone(r:(r+7),c:(c+7)) = extract(dct2(seeded_block), depth);
    end
end

figure;imshow(uint8(dave))
% figure;imshow(uint8(daveOrig - dave ))

figure;imshow(seed)
figure;imshow(uint8(seedClone))