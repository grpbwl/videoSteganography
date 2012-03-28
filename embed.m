function [ seeded_carrier ] = embed( carrier, seed, depth )
%EMBED Embeds a matrix into another.
%   Detailed explanation goes here

% TODO: Decide on the bit precision
bit_precision = 8;

% Copying values to seeded carrier
seeded_carrier = carrier;

% Iterate through the elements of the seed matrix
for r=1:size(seed,1)
    for c=1:size(seed,2)
        % Perform the actual embedding
        msb = bit_precision; 
        for lsb=1:depth
            seeded_carrier = bitset(seeded_carrier,lsb,bitget(seed,msb));
            msb = msb - 1;
        end
    end
end

% DEBUG: Printing out the binary just to confirm.
disp(dec2bin(seeded_carrier,bit_precision))

