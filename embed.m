function [ seeded_carrier ] = embed( carrier, seed, depth )
%EMBED Embeds a matrix into another.
%   carrier is a value in the frequency domain
%   seed is a number that needs to be embedded in the carrier value
%   depth is the number of bits in the seed.

% TODO: Decide on the bit precision
bit_precision = 8;

% Pre-process carrier
int_carrier = fix(carrier);

% This wont work if values are negtive or will it?
mantissa = carrier - int_carrier;

% Copying values to seeded carrier
seeded_carrier = int_carrier;

% Extract negbit
negbit = 0;
if seeded_carrier < 0
    negbit = 1;
    seeded_carrier = abs(seeded_carrier);
end

seeded_carrier = uint32(seeded_carrier);

% Perform embedding in correct order.
for lsb=1:depth
    seeded_carrier = bitset(seeded_carrier,lsb, 0);
end
seeded_carrier = bitor(seeded_carrier,uint32(seed));

% Casting back to originating class.
seeded_carrier = cast(seeded_carrier,class(carrier));
% seeded_carrier = double(seeded_carrier);

% Restoring negbit
if negbit
    seeded_carrier = -seeded_carrier;
end

seeded_carrier = seeded_carrier + mantissa;

% DEBUG: Printing out the binary just to confirm.
%disp(dec2bin(seeded_carrier,bit_precision))
end