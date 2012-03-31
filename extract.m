function [ seed ] = extract( seeded_carrier , depth)
%EXTRACT Extracts matrix
%   TODO: Detailed explanation goes here

% TODO: Decide on the bit precision
bit_precision = 8;

% Pre-process seeded carrier, truncate, abs, convert to uint32
carrier = uint32(abs(fix(seeded_carrier)));

% Obtain the last depth bits.
bitstring = dec2bin(carrier, bit_precision)';
seedstring = bitstring(bit_precision-depth+1:size(bitstring,1));

% Convert string to a number and pad it to be the correct bit size
seed = uint8(bin2dec(seedstring'));
seed = bitshift(seed,bit_precision-depth);

% DEBUG: Printing out the binary just to confirm.
% disp(dec2bin(seed,bit_precision))
end

