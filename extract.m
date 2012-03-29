function [ seed ] = extract( seeded_carrier , depth)
%EXTRACT Extracts matrix
%   TODO: Detailed explanation goes here

% TODO: Decide on the bit precision
bit_precision = 8;

% Pre-process seeded carrier
int_scarrier = abs(fix(seeded_carrier));

% Initialize seed.
seed = zeros(size(seeded_carrier));

% Iterate through carrier
for r=1:size(int_scarrier,1)
    for c=1:size(int_scarrier,2)     
        
        bitstring = '';
        
        % Extract the bits to a certain depth
        for bit=1:depth
            bitstring = strcat(bitstring,num2str(bitget(int_scarrier(r,c),bit)));
        end
        
        % TODO: Once I test this and it works, I'll compress to one
        % statement.
        % Store the binary value as a decmial.
        decValue = bin2dec(bitstring);
        % Must pad the value to matche the precision
        decValue = bitshift(decValue, bit_precision-depth);
        seed(r,c) = decValue;
    end
end

% DEBUG: Printing out the binary just to confirm.
% disp(dec2bin(seed,bit_precision))
end

