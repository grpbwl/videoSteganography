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
    currentCarrier = rgb2gray(seededCarrier(frame).cdata(:,:,:));
    
    % Convert seed and carrier into a 1D array
    dctCarrier = mbdct2(currentCarrier,0);
    carrier1d = reshape(dctCarrier',format.cif(1)*format.cif(2),1);

    % Create place to hold recovered bits.
    outputBits = zeros(format.qcif(1)*format.qcif(2),1);

    bitCounter = 1; lsb = 1;
    for i=1:size(carrier1d,1)
        if( key(i) == 1 )
            % I have 4 bits
            extractedValue = extract(carrier1d(i),bitPrecision);

            % If bitCounter is odd then it's an MSB otherwise it's the LSB
            % so join.
            if lsb == 0
                % Shift so that the bits are in the correct location.
                outputBits(bitCounter) = bitshift(extractedValue,format.bitDepth-bitPrecision,format.bitDepth);
                
                % Don't increase the counter as another one goes in there
                % :)
%                 bitCounter = bitCounter + 1;
                lsb = 1;
            else
%                 outputBits(lsb) = bitshift(outputBits(lsb),format.bitDepth-bitPrecision,format.bitDepth);
                outputBits(bitCounter) = bitor(outputBits(bitCounter),extractedValue);  
                bitCounter = bitCounter + 1;
                lsb = 0;
            end

            if bitCounter > size(outputBits,1)
                break;
            end
        end
    end

    % Resize output
    output = im2uint8(ind2rgb(reshape(outputBits,format.qcif(1),format.qcif(2))',gray(256)));
    
    % Store in YUV Sequence
    sequence(frame).cdata = output;
end

end