function seed = extract( seededCarrier , bitPrecision, bitDepth, lsbFlag)
%EXTRACT Extracts specific set of bits from the seededCarrier
%   TODO: Detailed explanation goes here

% Pre-process seeded carrier, truncate, abs, convert to uint32
carrier = uint32(abs(fix(seededCarrier)));

% Extract the bits that we need, that is get the last bitPrecision bits.
seed = uint8(bitshift(carrier,0,bitPrecision));

% If msb shift accordingly.
if lsbFlag == 0
    seed = bitshift(seed,bitDepth-bitPrecision,bitDepth);
end

end