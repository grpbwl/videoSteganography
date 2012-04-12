function [ seed ] = extract( seeded_carrier , depth)
%EXTRACT Extracts matrix
%   TODO: Detailed explanation goes here

% TODO: Decide on the bit precision
bit_precision = 8;

% Pre-process seeded carrier, truncate, abs, convert to uint32
carrier = uint32(abs(fix(seeded_carrier)));

% % Obtain the last depth bits.
% bitstring = dec2bin(carrier, bit_precision)';
% offset = size(bitstring,1) - bit_precision;
% first = bit_precision-depth + 1 + offset;
% last = bit_precision + offset;
% seedstring = bitstring(first:last);

% Convert string to a number and pad it to be the correct bit size
seed = uint8(bitshift(carrier,0,depth));

% DEBUG: Printing out the binary just to confirm.
% disp(dec2bin(seed,bit_precision))
end

