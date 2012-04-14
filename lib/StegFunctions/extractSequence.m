function [ sequence ] = extractSequence( seededSequencePath, frameCount, key, bitPrecision )
%EXTRACTSEQUENCE Short desc.
%   Long Desc.

% Loading external constants
load('format');

% Pre-allocating for the embedded sequence
sequence = repmat(struct('cdata',uint8(zeros(format.qcif(2),format.qcif(1),3)),'colormap',cell(1)),1,frameCount);

% Get the sequence of frames.
seededCarrier = extractYuv(seededSequencePath,1,frameCount,'cif');

for frame=1:frameCount
    
    % Get current frame and convert 3 channels to grayscale.
%     currentCarrier = rgb2gray(seededCarrier(frame).cdata(:,:,:));
    currentCarrier = seededCarrier(frame).cdata(:,:,1);
    
    % Convert seed and carrier into a 1D array
    dctCarrier = mbdct2(currentCarrier,0);
    carrier1d = reshape(dctCarrier',format.cif(1)*format.cif(2),1);

    % Create place to hold recovered bits.
    outputBits = zeros(format.qcif(1)*format.qcif(2),1);

    bitCounter = 1; lsb = 0;
    for i=1:size(carrier1d,1)
        if( key(i) == 1 )            
            
            % Combine the values, crazy complex. So it'll 'or' the value
            % in the outputBits array and either the msb or the lsb of the
            % current carrier 8-bit string.
            outputBits(bitCounter) = bitor(outputBits(bitCounter), extract( carrier1d(i), bitPrecision, format.bitDepth, lsb ));
            
            % Increase the bitCounter only if it's lsb and flip the lsb
            % flag.
            if lsb
                bitCounter = bitCounter + 1;
                lsb = 0;
            else
                lsb = 1;
            end

            if bitCounter > size(outputBits,1)
                break;
            end
        end
    end

    % Resize output
    output = im2uint8(ind2rgb(reshape(outputBits,format.qcif(1),format.qcif(2))',gray(256)));
%     output = reshape(outputBits,format.qcif(1),format.qcif(2))';
    
    % Store in YUV Sequence
    sequence(frame).cdata = output;
%     sequence(frame).cdata(:,:,1) = uint8(output);
%     sequence(frame).cdata(:,:,2) = seededCarrier(frame).cdata(:,:,2);
%     sequence(frame).cdata(:,:,3) = seededCarrier(frame).cdata(:,:,3);
end

end