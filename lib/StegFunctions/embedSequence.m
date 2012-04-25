function [ seededSequence , key ] = embedSequence( carrierPath, seedPath, frameCount , key, bitPrecision )
%EMBEDSEQUENCE Short Description
%   Long Description

% Load video dimensions and bitDepth
load('format');
cif = format.cif;
qcif = format.qcif;
bitDepth = format.bitDepth;

% Pre-allocating space for the seeded sequence.
seededSequence = repmat(struct('cdata',uint8(zeros(cif(2),cif(1),3)),'colormap',cell(1)),1,frameCount);

% Get the sequence of frames.
carrier = extractYuv(carrierPath,51,55, 'cif');
seed = extractYuv(seedPath, 1, frameCount, 'qcif');

% If key is NaN, generate a random key
if isnan(key)
    key = generateRandomMask(cif(1),cif(2));
end

parfor frame=1:frameCount
    %% Read current image and convert to grayscale.
    % Get all three channels and convert to true grayscale.
    currentSeed = seed(frame).cdata(:,:,1); % Getting Y-Channel
    currentCarrier = carrier(frame).cdata(:,:,1); % Getting Y-Channel

    %% Embed Seed
    % Apply DCT to carrier
    dctCarrier= mbdct2(currentCarrier,0);

    % Convert seed and carrier into a 1D array
    carrier1d = reshape(dctCarrier',cif(1)*cif(2),1);
    seed1d = reshape(currentSeed',qcif(1)*qcif(2),1);

    % Convert seed to binary and split it up
    seedMSB = bitshift(seed1d,bitPrecision-bitDepth,bitPrecision); % Shifts right bitDepth-bitPrecision bits and keep bitPrecision bits.
    seedLSB = bitshift(seed1d,0,bitPrecision);                     % Shifts 0 bits, and keeps bitPrecision bits.

    % Iterate through the carrier array
    msb = 1; lsb = 1;
    for i=1:size(carrier1d,1)  
        % If the key is set then we encode the next value here.
        if( key(i) == 1 ) % TODO: fix slicing?

            % Check which is next msb or lsb, give msb preferrence
            if msb <= lsb
                currentSeed = seedMSB(msb,:);
                msb = msb + 1;
            else
                currentSeed = seedLSB(lsb,:);
                lsb = lsb + 1;
            end

            % Embed the corresponding part of the seed in here.
            carrier1d(i) = embed(carrier1d(i),currentSeed, bitPrecision );

            if lsb > size(seedLSB,1)
                break;
            end
        end
    end

    % Convert carrier back to 2D
    seeded_carrier = reshape(carrier1d,cif(1),cif(2))';

    % Apply IDCT to the Y-Channel.
    seeded_carrier = uint8(mbdct2(seeded_carrier,1));
    
    % Add to the sequence 
    seededSequence(frame).cdata(:,:,1) = seeded_carrier;%carrier(frame).cdata(:,:,1);
    seededSequence(frame).cdata(:,:,2) = carrier(frame).cdata(:,:,2);
    seededSequence(frame).cdata(:,:,3) = carrier(frame).cdata(:,:,3);
end