function [ sequence ] = extractSequence( seededSequencePath, frameCount, key, bitPrecision )
%EXTRACTSEQUENCE Short desc.
%   Long Desc.

% Loading external constants
load('format');
fDepth = 5;
% Pre-allocating for the embedded sequence
sequence = repmat(struct('cdata',uint8(zeros(format.qcif(2),format.qcif(1),3)),'colormap',cell(1)),1,frameCount);

% Get the sequence of frames.
seededCarrier = extractYuv(seededSequencePath,1,frameCount*5,'cif');
% Create place to hold recovered bits.
outputBits = zeros(format.qcif(1)*format.qcif(2),1);

seedFrame = 1;
lsb = 0;
frame = 1;
for carrierFrame=fDepth*frame-(fDepth-1):carrierFrame*frame
        
    bit = extract(seededCarrier(carrierFrame)
    
    % Change the lsb bit.
    if( mod(carrierFrame,5) == 0 )
        lsb = 1;
    else 
        lsb = 0;
    end
    
end

end