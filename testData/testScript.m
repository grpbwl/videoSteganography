%% Parameters
load('format');
f = 5;
bp = [1 2 4 5];
carrierPath = 'bus_cif.yuv';
seedPath = 'foreman_qcif.yuv';
carrier = extractYuv(carrierPath,1,f,'cif');
seed = extractYuv(seedPath,1,f,'qcif');
carrierOutput = '_output.yuv';
seedOutput = '_seed.yuv';

clear key;
load('key');
%% Embed the seed image.
tic
[s,k] = embedSequence(carrierPath,seedPath,f,key,bp(3));
toc
saveFileYuv(s,strcat(int2str(bp(3)),carrierOutput),1,0);
% for i=1:size(bp,2)
%     [s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',f,key,bp(i));
%     saveFileYuv(s,strcat(int2str(bp(i)),carrierOutput),1,0);
%     ssimValue = ssim(carrier.cdata(:,:,1),s.cdata(:,:,1));
%     psnrValue = PSNR(carrier.cdata(:,:,1),s.cdata(:,:,1));
%     sprintf('SSIM: %.4f\n%s',ssimValue,psnrValue)
% end

%% Extract embedded frame.
tic
o = extractSequence(strcat(int2str(bp(4)),carrierOutput),f,key,bp(4));
toc
saveFileYuv(o,strcat(int2str(bp(4)),seedOutput),1,1);
% for i=1:size(bp,2)
%     o = extractSequence(strcat(int2str(bp(i)),carrierOutput),f,key,bp(i));
%     ssimValue = ssim(seed.cdata(:,:,1),o.cdata(:,:,1));
%     psnrValue = PSNR(seed.cdata(:,:,1),o.cdata(:,:,1));
%     sprintf('SSIM: %.4f\n%s',ssimValue,psnrValue)
% % saveFileYuv(o,'seed.yuv',1,1);
% end
