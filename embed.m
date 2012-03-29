function [ seeded_carrier ] = embed( carrier, seed, depth )
%EMBED Embeds a matrix into another.
%   TODO: Detailed explanation goes here

% TODO: Decide on the bit precision
bit_precision = 8;

% Pre-process carrier
integer_carrier = int32(fix(carrier));

% This wont work if values are negtive or will it?
mantissa = carrier - integer_carrier;

% Copying values to seeded carrier
seeded_carrier = integer_carrier;

% Iterate through the elements of the seed matrix
for r=1:size(seed,1)
    for c=1:size(seed,2)
        
        sc = seeded_carrier(r,c);
        negbit = 0;
        % Filter out values before starting with the bit embedding
        if sc < 0
            negbit = 1;
            sc = abs(sc);
        end
        
        
        % Perform the actual embedding
        msb = bit_precision; 
        for lsb=1:depth
            seeded_carrier(r,c) = bitset(seeded_carrier(r,c),lsb,bitget(seed(r,c),msb));
            msb = msb - 1;
        end
    end
end

% DEBUG: Printing out the binary just to confirm.
%disp(dec2bin(seeded_carrier,bit_precision))
end