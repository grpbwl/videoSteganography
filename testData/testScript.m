%% Parameters
f = 1;
bp = 5;
clear key;
load('key');
%% Embed the seed image.
[s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',f,key,bp);
saveFileYuv(s,'test.yuv',1,0);

%% Extract embedded frame.
o = extractSequence('test.yuv',f,k,bp);
saveFileYuv(o,'seed.yuv',1,1);
