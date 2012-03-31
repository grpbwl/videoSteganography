% Reading the information and storing it to get rid of the 4 MSB
% dave = imread('data\daveg01.bmp');
dave = imread('data/daveg01.bmp');
seedSize = 32;
dave = imresize( dave , [128 128]);
seed = imresize( dave , [seedSize seedSize]);
depth = 8;
bp = 1;

% figure;imshow(dave)

daveOrig = dave;
seedClone = size(seed);

% Apply DCT to dave
dctDave = mbdct2(dave,0);

% Convert seed and carrier into a 1D array
dave1d = reshape(dctDave',128*128,1);
seed1d = reshape(seed',seedSize*seedSize,1);

% Iterate through the seed array
j = 1;
for i=1:size(seed1d,1)
    % Assuming that the seed is int.
    currentSeed = dec2bin(seed1d(i))';
    
    % Itearating from the 1st MSB to the last bit.
    for bit=1:bp:size(currentSeed,1)
        
        % Plant the seed
        seeded_carrier = embed(dave1d(j),bin2dec(currentSeed(1:bp)'),bp);
        dave1d(j) = seeded_carrier;
        
        % Truncate currentSeed
        currentSeed = currentSeed(bp+1:size(currentSeed,1));
        
        % Increase counter for carrier's index
        j = j + 1;
    end 
end

% Convert carrier back to 2D
seeded_dave = reshape(dave1d,128,128)';

% Testing Inverse DCT
dctTest = seeded_dave;

% Apply IDCT to dave
seeded_dave = mbdct2(seeded_dave,1);

% figure;imshow(uint8(dave))
% figure;imshow(uint8(daveOrig - dave ))

% figure;imshow(seed)
% figure;imshow(uint8(seedClone))