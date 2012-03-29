function [ seeded_carrier ] = embed( carrier, seed, depth )
%EMBED Embeds a matrix into another.
%   TODO: Detailed explanation goes here

% TODO: Decide on the bit precision
bit_precision = 4;

% Pre-process carrier
integer_carrier = fix(carrier);

% This wont work if values are negtive or will it?
mantissa = carrier - integer_carrier;

% Copying values to seeded carrier
seeded_carrier = integer_carrier;

% Iterate through the elements of the seed matrix
for r=1:size(seed,1)
    for c=1:size(seed,2)
        
        % Get alias for the current sc position
        sc = seeded_carrier(r,c);
        negbit = 0;
        
        % Set negbit if negative
        if sc < 0
            negbit = 1;
            sc = abs(sc);
        end
        
        % TODO: Cast to correct type.
        sc = uint32(sc);
        
        % Perform the actual embedding
        msb = bit_precision; 
        for lsb=1:depth
            sc = bitset(sc,lsb,bitget(seed(r,c),msb));
            msb = msb - 1;
        end
        
        % TODO: Cast back to original carrier type
        sc = cast(sc,class(carrier));
        
        % Unset negbit if it ever was negative
        if negbit
            sc = -sc;
        end
        
        % Store value back
        seeded_carrier(r,c) = sc;
    end
end

% Add the mantissa back
seeded_carrier = seeded_carrier + mantissa;

% DEBUG: Printing out the binary just to confirm.
%disp(dec2bin(seeded_carrier,bit_precision))
end