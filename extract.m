function [ seed ] = extract( seeded_carrier , depth)
%EXTRACT Extracts matrix
%   TODO: Detailed explanation goes here

% Pre-process seeded carrier, truncate, abs, convert to uint32
carrier = uint32(abs(fix(seeded_carrier)));

% Convert string to a number and pad it to be the correct bit size
seed = uint8(bitshift(carrier,0,depth));

end

