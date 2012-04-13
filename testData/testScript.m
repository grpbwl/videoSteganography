%% Parameters
f = 5;
bp = 4

%% Embed the seed image.
[s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',f,NaN,bp);
saveFileYuv(s,'test.yuv','w');

%% Extract embedded frame.
o = extractSequence('test.yuv',f,k,bp);
saveFileYuv(o,'seed.yuv','w');
