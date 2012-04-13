%% Embed the seed image.
[s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',1,NaN,4);
saveFileYuv(s,'test.yuv','w');

%% Extract embedded frame.
o = extractSequence('test.yuv',1,k,4);
saveFileYuv(o,'seed.yuv','w');
