%% Parameters
load('format');
% carrier = loadFileYuv('bus_cif.yuv',format.cif(1),format.cif(2),1);
% seed = loadFileYuv('foreman_qcif.yuv',format.qcif(1),format.qcif(2),1);
carrierOutput = '_output.yuv';
seedOutput = '_seed.yuv';
f = 1;
bp = [1 2 4 5];
clear key;
load('key');
%% Testing the other one
[s,k] = embedSequence5('bus_cif.yuv','foreman_qcif.yuv',f,key,bp(4));
saveFileYuv(s,'test.yuv',1,0);

%% Testing the other other one
o = extractSequence5('test.yuv',f,key,bp(1));
saveFileYuv(o,'seed.yuv',1,1);

%% Embed the seed image.
for i=1:size(bp,2)
    [s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',f,key,bp(i));
    saveFileYuv(s,strcat(int2str(bp(i)),carrierOutput),1,0);
    ssimValue = ssim(carrier.cdata(:,:,1),s.cdata(:,:,1));
    psnrValue = PSNR(carrier.cdata(:,:,1),s.cdata(:,:,1));
    sprintf('SSIM: %.4f\n%s',ssimValue,psnrValue)
end

%% Extract embedded frame.
for i=1:size(bp,2)
    o = extractSequence(strcat(int2str(bp(i)),carrierOutput),f,key,bp(i));
    ssimValue = ssim(seed.cdata(:,:,1),o.cdata(:,:,1));
    psnrValue = PSNR(seed.cdata(:,:,1),o.cdata(:,:,1));
    sprintf('SSIM: %.4f\n%s',ssimValue,psnrValue)
% saveFileYuv(o,'seed.yuv',1,1);
end
