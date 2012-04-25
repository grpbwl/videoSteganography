%% Parameters
load('format');
f = 5;
bp = [1 2 4 5];
carrierPath = 'BigBuckBunny_CIF_24fps.yuv';
seedPath = 'foreman_qcif.yuv';
carrier = extractYuv(carrierPath,51,55,'cif');
seed = extractYuv(seedPath,1,f,'qcif');
carrierOutput = '_output.yuv';
seedOutput = '_seed.yuv';

% clear key;
% load('key');
%% Embed the seed image.
tic
[s,k] = embedSequence(carrierPath,seedPath,f,NaN,bp(3));
toc
saveFileYuv(s,strcat(int2str(bp(3)),carrierOutput),1,0);
ssimValue = 0;
psnrValue = 0;
for i=1:size(s,2)
    %[s,k] = embedSequence('bus_cif.yuv','foreman_qcif.yuv',f,key,bp(i));
    %saveFileYuv(s,strcat(int2str(bp(i)),carrierOutput),1,0);
    ssimValue = ssimValue + ssim(carrier(i).cdata(:,:,1),s(i).cdata(:,:,1));
    psnrValue = psnrValue + PSNR(carrier(i).cdata(:,:,1),s(i).cdata(:,:,1));
    % sprintf('SSIM: %.4f\n%s',ssimValue,psnrValue)
end

%% Extract embedded frame.
tic
o = extractSequence(strcat(int2str(bp(3)),carrierOutput),f,key,bp(3));
toc
saveFileYuv(o,strcat(int2str(bp(3)),seedOutput),1,1);
ssimValue = 0;
psnrValue = 0;
for i=1:size(o,2)
%     o = extractSequence(strcat(int2str(bp(i)),carrierOutput),f,key,bp(i));
    ssimValue = ssimValue + ssim(seed(i).cdata(:,:,1),o(i).cdata(:,:,1));
    psnrValue = psnrValue + PSNR(seed(i).cdata(:,:,1),o(i).cdata(:,:,1));
%     sprintf('SSIM: %.4f\n%s',ssimValue,psnrValue)
% saveFileYuv(o,'seed.yuv',1,1);
end
ssimValue/5
psnrValue/5

