% Reading the information and storing it to get rid of the 4 MSB
% dave = imread('data\daveg01.bmp');

%% Read the Image and scale to proper dimensions
dave = imread('data/daveg01.bmp');
qcif = [ 176 144 ] ;
cif = [ 352 288 ];
dave = imresize( dave , [cif(1) cif(2)]);
seed = imresize( dave , [qcif(1) qcif(2)]);

%% Parameters for .... something or another. 
depth = 8;
bp = 4;
key = randi([0 1], cif(1)*cif(2),1);

%% Embed Seed
daveOrig = dave;
seedClone = size(seed);

% Apply DCT to dave
dctDave = mbdct2(dave,0);

% Convert seed and carrier into a 1D array
dave1d = reshape(dctDave',cif(1)*cif(2),1);
seed1d = reshape(seed',qcif(1)*qcif(2),1);
output = size(seed1d); output = uint8(output);

% Iterate through the seed array
j = 1;
for i=1:2:size(dave1d,1)
    
    currentSeed = '';
    
    % If the key is set then we encode the next value here.
    if( key(i) == 1 )
        currentSeed = dec2bin(seed1d(j),8)';
        dave1d(i) = embed(dave1d(i),bin2dec(currentSeed(1:4)'), bp );
        j = j + 1;
    end
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
seeded_dave = reshape(dave1d,cif(1),cif(2))';

% Testing Inverse DCT
dctTest = seeded_dave;

% Apply IDCT to dave
seeded_dave = mbdct2(seeded_dave,1);

%% Retrieve Seed
% Convert seed and carrier into a 1D array
dctDave = mbdct2(seeded_dave,0);

dave1d = reshape(dctDave',cif(1)*cif(2),1);
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
output = reshape(output,qcif(1),qcif(2))';