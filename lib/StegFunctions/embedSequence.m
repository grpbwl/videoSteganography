function [ seededSequence , key ] = embedSequence( carrierPath, seedPath, frameCount , key, bitPrecision )
%EMBED Short Description
%   Long Description

% Load video dimensions
load('format');
bitDepth = 8;

% Pre-allocating space for the 
seededSequence = repmat(struct('cdata',uint8(zeros(format.cif(2),format.cif(1),3)),'colormap',cell(1)),1,frameCount);

% Get the sequence of frames.
carrier = extractSequence(carrierPath,1,frameCount, 'cif');
seed = extractSequence(seedPath, 1, frameCount, 'qcif');

parfor frame=1:frameCount
    %% Read current image and convert to grayscale.
    % Get all three channels and convert to true grayscale.
    currentSeed = rgb2gray(seed(frame).cdata(:,:,:));
    currentCarrier = rgb2gray(carrier(frame).cdata(:,:,:));

    %% Embed Seed
    % Apply DCT to carrier
    dctCarrier= mbdct2(currentCarrier,0);

    % Convert seed and carrier into a 1D array
    carrier1d = reshape(dctCarrier',format.cif(1)*format.cif(2),1);
    seed1d = reshape(currentSeed',format.qcif(1)*format.qcif(2),1);

    % Convert seed to binary and split it up
    seedMSB = bitshift(seed1d,bitDepth-bitPrecision,bitPrecision); % Shifts left bitDepth-bitPrecision bits and keep bitPrecision bits.
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
    seeded_carrier = reshape(carrier1d,format.cif(1),format.cif(2))';

    % Apply IDCT to dave
    seeded_carrier = uint8(mbdct2(seeded_carrier,1));
    seeded_carrier = im2uint8(ind2rgb(seeded_carrier,gray(256)));
    
    % Add to the sequence 
    seededSequence(frame).cdata = seeded_carrier;
end