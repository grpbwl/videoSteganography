function [ seed ] = extract( seededCarrier , bitPrecision, bitDepth, lsbFlag)
%EXTRACT Extracts specific set of bits from the seededCarrier
%   TODO: Detailed explanation goes here

% Pre-process seeded carrier, truncate, abs, convert to uint32
carrier = uint32(abs(fix(seededCarrier)));

% Convert string to a number and pad it to be the correct bit size
if lsbFlag
    seed = uint8(bitshift(carrier,0,bitPrecision));
else
    seed = uint8(bitshift(carrier,bitDepth-bitPrecision,bitPrecision));
end

end

