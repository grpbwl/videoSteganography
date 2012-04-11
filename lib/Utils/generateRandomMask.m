function [ mask ] = generateRandomMask( m, n )
%GENERATERANDOMMASK Creates a mask containing random bits.
%   Generates a random mask of bits with size m*nx1
mask = randi([0 1], m*n,1);
end

