% Reading the information and storing it to get rid of the 4 MSB
% dave = imread('data\daveg01.bmp');

qcif = [ 176 144 ] ;
cif = [ 352 288 ];

F = 3;

% Pre-allocating
seeded_sequence = repmat(struct('cdata',uint8(zeros(cif(2),cif(1),3)),'colormap',cell(1)),1,F);

for frame=1:F
    %% Read the Image and scale to proper dimensions
    % Get all three channels and convert to true grayscale.
    [temp] = loadFileYuv('foreman_qcif.yuv',qcif(1),qcif(2),frame);
    seed = rgb2gray(temp.cdata(:,:,:));
    [temp] = loadFileYuv('bus_cif.yuv',cif(1),cif(2),frame);
    carrier = rgb2gray(temp.cdata(:,:,:));

    % carrier = imresize( carrier , [cif(1) cif(2)]);
    % seed = imresize( carrier , [qcif(1) qcif(2)]);

    %% Parameters for .... something or another. 
    depth = 8;
    bp = 4;
    key = randi([0 1], cif(1)*cif(2),1);

    %% Embed Seed
    daveOrig = carrier;
    seedClone = size(seed);

    % Apply DCT to dave
    dctCarrier= mbdct2(carrier,0);

    % Convert seed and carrier into a 1D array
    carrier1d = reshape(dctCarrier',cif(1)*cif(2),1);
    seed1d = reshape(seed',qcif(1)*qcif(2),1);

    % Convert seed to binary and split it up
    binarySeed = dec2bin(seed1d,8);
    seedMSB = binarySeed(:,1:4);
    seedLSB = binarySeed(:,5:8);

    % Iterate through the carrier array
    msb = 1; lsb = 1;
    for i=1:size(carrier1d,1)  
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
            carrier1d(i) = embed(carrier1d(i),currentSeed, bp );

            if lsb > size(seedLSB,1)
                break;
            end
        end
    end

    % Convert carrier back to 2D
    seeded_carrier = reshape(carrier1d,cif(1),cif(2))';

    % Apply IDCT to dave
    seeded_carrier = uint8(mbdct2(seeded_carrier,1));
    seeded_carrier = im2uint8(ind2rgb(seeded_carrier,gray(256)));
    
    
    % Add to the sequence 
    seeded_sequence(frame).cdata = seeded_carrier;
%     seeded_sequence(frame).cdata(:,:,1) = seeded_carrier;
%     seeded_sequence(frame).cdata(:,:,2) = seeded_carrier;
%     seeded_sequence(frame).cdata(:,:,3) = seeded_carrier;
end

% Save the sequence
saveFileYuv(seeded_sequence, 'new_carrier.yuv', 'w');


%% Retrieve Seed
% Convert seed and carrier into a 1D array
dctCarrier = mbdct2(seeded_carrier,0);
carrier1d = reshape(dctCarrier',cif(1)*cif(2),1);

% Create place to hold recovered bits.
outputMSB = zeros(qcif(1)*qcif(2),1);
outputLSB = zeros(qcif(1)*qcif(2),1);

msb = 1; lsb = 1;
for i=1:size(carrier1d,1)
    if( key(i) == 1 )
        % I have 4 bits
        hword = extract(carrier1d(i),bp);
        
        % Inserting in the correct place
        if msb <= lsb
            outputMSB(msb) = hword;
            msb = msb + 1;
        else
            outputMSB(lsb) = bitshift(outputMSB(lsb),bp);
            outputMSB(lsb) = bitor(outputMSB(lsb),hword);  
%             outputLSB(lsb) = hword;
            lsb = lsb + 1;
            
            % Consider joining here.
        end
        
        if lsb > size(outputLSB,1)
            break;
        end
    end
end

% Resize output
output = reshape(outputMSB,qcif(2),qcif(1))';