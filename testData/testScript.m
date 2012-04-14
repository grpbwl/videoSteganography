%% Parameters
f = 1;
bp = 4;
clear key;
% load('key');
%% Embed the seed image.
[s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',f,NaN,bp);
saveFileYuv(s,'test.yuv','w');

%% Extract embedded frame.
o = extractSequence('test.yuv',f,k,bp);
saveFileYuv(o,'seed.yuv','w');
