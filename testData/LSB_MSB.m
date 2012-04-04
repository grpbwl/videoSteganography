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

% Convert seed to binary and split it up
binarySeed = dec2bin(seed1d,8);
seedMSB = binarySeed(:,1:4);
seedLSB = binarySeed(:,5:8);

%% Iterate through the carrier array
msb = 1; lsb = 1;
for i=1:size(dave1d,1)  
    % If the key is set then we encode the next value here.
    if( key(i) == 1 )
        
        % Check which is next msb or lsb, give msb preferrence
        if msb <= lsb
            currentSeed = bin2dec(seedMSB(msb,:));
            msb = msb + 1;
        else
            currentSeed = bin2dec(seedLSB(lsb,:));
            lsb = lsb + 1;
        end
        
        % Embed the corresponding part of the seed in here.
        dave1d(i) = embed(dave1d(i),currentSeed, bp );
        
        if lsb > size(seedLSB,1)
            break;
        end
    end
end

% Convert carrier back to 2D
seeded_dave = reshape(dave1d,cif(2),cif(1))';

% Apply IDCT to dave
seeded_dave = mbdct2(seeded_dave,1);


%% Retrieve Seed
% Convert seed and carrier into a 1D array
dctDave = mbdct2(seeded_dave,0);

dave1d = reshape(dctDave',cif(1)*cif(2),1);
% outputMSB = zeros(qcif(1)*qcif(2)/2

output = zeros(size(seed1d)); output = uint8(output);
msb = 1;
for i=1:size(output,1)
    valuesPerValue = 8/bp;
    bitstring = '';
    
    for b=1:valuesPerValue
        value = dave1d(msb);
        %Extract one set of bits
        val = extract(value,bp);
        bitstring = cat(2, bitstring,dec2bin(val,bp));
        
        msb = msb + 1;
    end
    
    % Store back and do some padding
    output(i) = uint8(bin2dec(bitstring));
%     output(i) = bitshift(output(i),
end

% Resize output
output = reshape(output,qcif(1),qcif(2))';