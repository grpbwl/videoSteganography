function [ seededSequence , key ] = embedSequence( carrierPath, seedPath, frameCount , key, bitPrecision )
%EMBEDSEQUENCE Short Description
%   Long Description

% Load video dimensions and bitDepth
load('format');
cif = format.cif;
qcif = format.qcif;
bitDepth = format.bitDepth;
fDepth = 5;

% Pre-allocating space for the seeded sequence, which will be multiplied by
% a factor of fDepth
seededSequence = repmat(struct('cdata',uint8(zeros(cif(2),cif(1),3)),'colormap',cell(1)),1,frameCount*fDepth);

% Get the sequence of frames.
carrier = extractYuv(carrierPath,1,frameCount*fDepth, 'cif');
seed = extractYuv(seedPath, 1, frameCount, 'qcif');

% If key is NaN, generate a random key
if isnan(key)
    key = generateRandomMask(cif(1),cif(2));
end


for frame=1:frameCount
    %% Read current image and convert to grayscale.
    % Get all three channels and convert to true grayscale.
    slicedSeed = seed(frame);
    currentSeed = slicedSeed.cdata(:,:,1); % Getting Y-Channel
    
    % Pre-allocate memory for carriers
    carriers = repmat(struct('data',zeros(cif(1),cif(2),3)),fDepth,1);
    carriersDCT = repmat(struct('data',zeros(cif(1)*cif(2),1)),fDepth,1);
    
    % Get the next 5 valid frames and store them in dct form.
    carrierFrame = fDepth*frame-(fDepth-1);
    for i=1:fDepth
        carriers(i).data= carrier(carrierFrame).cdata; % Getting YUV-Channels
        carriersDCT(i).data = reshape(mbdct2(carriers(i).data(:,:,1)',0),cif(1)*cif(2),1); % Getting DCT of Y channel.
        carrierFrame = carrierFrame + 1;
    end
    
    % Make the seed be a 1 dimensional array.
    seed1d = reshape(currentSeed',qcif(1)*qcif(2),1);
    
    % Convert seed to binary and split it up
    seedMSB = bitshift(seed1d,bitPrecision-bitDepth,bitPrecision); % Shifts right bitDepth-bitPrecision bits and keep bitPrecision bits.
    seedLSB = bitshift(seed1d,0,bitPrecision);                     % Shifts 0 bits, and keeps bitPrecision bits.
    
    i = 1;
    msb = 1; lsb = 1;
    while( i <= size(key,1) )
        if( key(i) == 1 )
             % Check which is next msb or lsb, give msb preferrence
            if msb <= lsb
                currentSeed = seedMSB(msb);
                msb = msb + 1;
            else
                currentSeed = seedLSB(lsb);
                lsb = lsb + 1;
            end
            % Store one bit into the fDepth frames
            for j=1:fDepth
               bit = bitget(currentSeed,j);
               carriersDCT(j).data(i) = embed(carriersDCT(j).data(i),bit,1);
            end
            
            if lsb > size(seedLSB,1)
                break;
            end
        end
        i = i + 1;
    end
    
    %% Put everything back from those 5 frames.
    carrierFrame = fDepth*frame-(fDepth-1);
    for i=1:fDepth
        seededSequence(carrierFrame).cdata(:,:,1) = uint8(mbdct2(reshape(carriersDCT(i).data,cif(1),cif(2))',1));
        seededSequence(carrierFrame).cdata(:,:,2) = carriers(i).data(:,:,2);
        seededSequence(carrierFrame).cdata(:,:,3) = carriers(i).data(:,:,3);
        carrierFrame = carrierFrame + 1;
    end    
end