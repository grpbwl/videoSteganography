function [ mbdctmatrix ] = mbdct2( matrix , inv)
%MBDCT2 Apply dct2 to every 8x8 macroblock in matrix.
%   Takes in a full matrix, and applies 2D DCT on every 8x8 macro block. It
%   returns a matrix of the original input size, with 8x8 2D DCT values.
%   If inv = 1, this algorith will perform 2D IDCT instead of 2D DCT.

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