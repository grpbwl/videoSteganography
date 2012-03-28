clear
% Reading the information and storing it to get rid of the 4 MSB
dave = imread('data\daveg01.bmp');
dave = imresize( dave , [128 128]);
seed = imresize( dave , [32 32]);
depth = 4;

daveOrig = dave;
seedClone = size(seed);
figure;imshow(dave)

% Iterate in increments of 8's because we are doing 8x8 blocks
for r=1:8:size(seed,1)
    for c=1:8:size(seed,2)     
        % For every block
        seeded_block = embed(dave(r:(r+7),c:(c+7)),seed(r:(r+7),c:(c+7)),depth);
        
        % Apply seed to image
        dave(r:(r+7),c:(c+7)) = seeded_block;
        
        % Retrieve
        seedClone(r:(r+7),c:(c+7)) = extract(seeded_block, depth);
    end
end

figure;imshow(dave)
figure;imshow(uint8(daveOrig - dave ))

figure;imshow(seed)
figure;imshow(seedClone)