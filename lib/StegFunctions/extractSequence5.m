function [ sequence ] = extractSequence5( seededSequencePath, frameCount, key, bitPrecision )
%EXTRACTSEQUENCE Short desc.
%   Long Desc.

% Loading external constants
load('format');
fDepth = 5;
cif = format.cif;
qcif = format.qcif;
bitDepth = format.bitDepth;
fDepth = 5;

% Force bitPrecision to 1
bitPrecision = 1;

% Pre-allocating for the embedded sequence
sequence = repmat(struct('cdata',uint8(zeros(qcif(2),qcif(1),3)),'colormap',cell(1)),1,frameCount);

% Get the sequence of frames.
carrier = extractYuv(seededSequencePath,1,frameCount*5,'cif');
% Create place to hold recovered bits.
outputBits = zeros(qcif(1)*qcif(2),1);

for frame=1:frameCount
    %% Read current image and convert to grayscale.
%     % Get all three channels and convert to true grayscale.
%     slicedSeed = seed(frame);
%     currentSeed = slicedSeed.cdata(:,:,1); % Getting Y-Channel
    
    % Pre-allocate memory for carriers
%     carriers = repmat(struct('data',zeros(cif(1),cif(2),3)),fDepth,1);
    carriersDCT = repmat(struct('data',zeros(cif(1)*cif(2),1)),fDepth,1);
    
    % Get the next 5 valid frames and store them in dct form.
    carrierFrame = fDepth*frame-(fDepth-1);
    for i=1:fDepth
%         carriers(i).data= carrier(carrierFrame).cdata; % Getting YUV-Channels
        carriersDCT(i).data = reshape(mbdct2(carrier(carrierFrame).cdata(:,:,1)',0),cif(1)*cif(2),1); % Getting DCT of Y channel.
        carrierFrame = carrierFrame + 1;
    end
    
    i = 1;
    msb = 1;bitCounter = 1;
    while( i <= size(key,1) )
        if( key(i) == 1 )
                   
            if msb == 1
                temp = uint8(0);
                % Do the bottom 5 times
                for k=5:-1:1
                    extracted = extract(carriersDCT(k).data(i),bitPrecision,bitDepth,1);
                    % Bitshift the current bit one to the right and perform an
                    % OR operation with the upcoming bit.
                    temp = bitor(bitshift(temp,1),extracted);
                    % Reverse bit order. TODO: Must check if the bits are
                    % correct.
                end 
                msb = 0;
                outputBits(bitCounter) = bitshift(temp,3);
            else
                temp = uint8(0);
                % Do the bottom 5 times
                for k=1:5
                    extracted = extract(carriersDCT(k).data(i),bitPrecision,bitDepth,1);
                    % Bitshift the current bit one to the right and perform an
                    % OR operation with the upcoming bit.
                    temp = bitor(bitshift(temp,1),extracted);
                    % Reverse bit order. TODO: Must check if the bits are
                    % correct.
                end 
                outputBits(bitCounter) = bitor(outputBits(bitCounter),temp);
                bitCounter = bitCounter + 1;
                msb = 1;
            end
            
            % Bail if i is bigger than the size of the output bits.
            if bitCounter > size(outputBits,1)
                break;
            end
        end
        i = i + 1;
        

    end
    
    % Resize and format output
    output = im2uint8(ind2rgb(reshape(outputBits,qcif(1),qcif(2))',gray(256)));
    
    %% Put everything back from those 5 frames.
    sequence(frame).cdata = output;
end

end