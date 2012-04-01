% Reading the information and storing it to get rid of the 4 MSB
% dave = imread('data\daveg01.bmp');
dave = imread('data/daveg01.bmp');
seedSize = 64;
dave = imresize( dave , [128 128]);
seed = imresize( dave , [seedSize seedSize]);
depth = 8;
bp = 4;

% figure;imshow(dave)

daveOrig = dave;
seedClone = size(seed);

% Apply DCT to dave
dctDave = mbdct2(dave,0);

% Convert seed and carrier into a 1D array
dave1d = reshape(dctDave',128*128,1);
seed1d = reshape(seed',seedSize*seedSize,1);
output = size(seed1d); output = uint8(output);

% Iterate through the seed array
j = 1;
for i=1:size(seed1d,1)
    % Assuming that the seed is int.
    currentSeed = dec2bin(seed1d(i),8)';
    
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

figure;imshow(uint8(seeded_dave));


% Retrieve seed

% Convert seed and carrier into a 1D array
dctDave = mbdct2(seeded_dave,0);

dave1d = reshape(dctDave',128*128,1);
output = zeros(size(seed1d)); output = uint8(output);
j = 1;
for i=1:size(output,1)
    valuesPerValue = 8/bp;
    bitstring = '';
    
    for b=1:valuesPerValue
        value = dave1d(j);
        %Extract one set of bits
        val = extract(value,bp);
        bitstring = cat(2, bitstring,dec2bin(val,bp));
        
        j = j + 1;
    end
    
    % Store back and do some padding
    output(i) = uint8(bin2dec(bitstring));
%     output(i) = bitshift(output(i),
end

% Resize output
output = reshape(output,seedSize,seedSize)';

% figure;imshow(uint8(dave))
% figure;imshow(uint8(daveOrig - dave ))

% figure;imshow(seed)
% figure;imshow(uint8(seedClone))