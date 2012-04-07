%% Retrieve Seed 8 seconds
qcif = [ 176 144 ] ;
cif = [ 352 288 ];
F=5;
depth = 8;
bp = 4;
% Pre-allocating
seed_sequence = repmat(struct('cdata',uint8(zeros(qcif(2),qcif(1),3)),'colormap',cell(1)),1,F);

parfor frame=1:F
    [temp] =  loadFileYuv('trigoman.yuv',cif(1),cif(2),frame);
    seeded_carrier = rgb2gray(temp.cdata(:,:,:));
    
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
    output = im2uint8(ind2rgb(reshape(outputMSB,qcif(1),qcif(2))',gray(256)));
    
    % Store in YUV Sequence
    seed_sequence(frame).cdata = output;
end

% Save the sequence
saveFileYuv(seed_sequence,'extracted_sequence.yuv','w');