function [ frequency ] = dct2( spatial )
%DCT2 2D Discrete cosine transform (DCT) of input
%   Detailed explanation goes here
frequency = dct(dct(spatial)')';
end

