function [mov] = newFileYuv(width, height)

subSampleMat = [1, 1; 1, 1];
sizeFrame = 1.5 * width * height;
imgRgb(:,:,1)=zeros(height,width);
imgRgb(:,:,2)=zeros(height,width);
imgRgb(:,:,3)=zeros(height,width);
mov = im2frame(imgRgb);