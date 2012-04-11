function [ mbdctmatrix ] = mbdct2( matrix , inv)
%MBDCT2 Apply dct2 to every 8x8 macroblock in matrix.
%   Detailed explanation goes here

mbdctmatrix = size(matrix);

for r=1:8:size(matrix,1)
    for c=1:8:size(matrix,2)
        if inv
            mbdctmatrix(r:r+7,c:c+7) = idct2(matrix(r:r+7,c:c+7));
        else
            mbdctmatrix(r:r+7,c:c+7) = dct2(matrix(r:r+7,c:c+7));
        end
    end
end

end