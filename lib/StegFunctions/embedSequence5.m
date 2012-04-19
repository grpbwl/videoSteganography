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


parfor frame=1:frameCount
    %% Read current image and convert to grayscale.
    % Get all three channels and convert to true grayscale.
    currentSeed = seed(frame).cdata(:,:,1); % Getting Y-Channel
    
    % Pre-allocate memory for carriers
    carriers = repmat(struct('data',zeros(cif(1),cif(2))),fDepth,1);
    
    % Get's us the corresponding frame to get.
    carrierFrame = fDepth*frame-(fDepth-1);
    for i=1:5
        carriers(i) = carrier(carrierFrame).cdata(:,:,1); % Getting Y-Channels
        carriers(i) = mbdct2(carriers(i),0); 
        carrierFrame = carrierFrame + 1;
    end
    
    
    
end