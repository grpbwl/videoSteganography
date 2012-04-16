function [ sequence ] = extractSequence( seededSequencePath, frameCount, key, bitPrecision )
%EXTRACTSEQUENCE Short desc.
%   Long Desc.

% Loading external constants
load('format');
cif = format.cif;
qcif = format.qcif;
bitDepth = format.bitDepth;

% Pre-allocating for the embedded sequence
sequence = repmat(struct('cdata',uint8(zeros(qcif(2),qcif(1),3)),'colormap',cell(1)),1,frameCount);

% Get the sequence of frames.
seededCarrier = extractYuv(seededSequencePath,1,frameCount,'cif');

parfor frame=1:frameCount
    
    % Get current frame's Y-Channel.
    currentCarrier = seededCarrier(frame).cdata(:,:,1);
    
    % Convert seed and carrier into a 1D array
    dctCarrier = mbdct2(currentCarrier,0);
    carrier1d = reshape(dctCarrier',cif(1)*cif(2),1);

    % Create place to hold recovered bits.
    outputBits = zeros(qcif(1)*qcif(2),1);

    bitCounter = 1; lsb = 0;
    for i=1:size(carrier1d,1)
        if( key(i) == 1 )            
            
            % Combine the values, crazy complex. So it'll 'or' the value
            % in the outputBits array and either the msb or the lsb of the
            % current carrier 8-bit string.
            outputBits(bitCounter) = bitor(outputBits(bitCounter), extract( carrier1d(i), bitPrecision, bitDepth, lsb ));
            
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
    output = im2uint8(ind2rgb(reshape(outputBits,qcif(1),qcif(2))',gray(256)));
    
    % Store in YUV Sequence
    sequence(frame).cdata = output;
end

end