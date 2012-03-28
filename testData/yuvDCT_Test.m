% Read one frame on a cif image.
height = 288;
width = 352;
[mov, rgbImg]= loadFileYuv('bus_cif.yuv',width, height, 1);
clear mov;

rgbImg = rgbImg(:,:,1);

% Resize to some values that can be 
scaledImg = imresize(rgbImg, [256 256]);

% Substract 128 and turn into double type matrix
scaledImg = double(scaledImg) - 128 ;

dctDomain = double(zeros(256));
inverseDctDomain = double(zeros(256));

for r=1:8:256
    for w=1:8:256
        
         % Apply 2D DCT
         mb = dct(scaledImg(r: (r + 7), w:(w+7)));
         mb = dct(mb')';
         test = dct2(scaledImg(r: (r + 7), w:(w+7)));
         
         %mb(1) = mb(1) + 100;
         
%          mb = abs(round(mb));
         
         % Zero out DCT high frequencies
%          c = 0;
%          for i=1:8
%              mb(8-c:8,i) = 0;
%              c = c + 1;
%          end
         
         % Store the macroblock in the dctDomain matrix
         dctDomain(r: (r + 7), w:(w+7)) = mb;
         
         % Attempt to reverse DCT to see effects
%          inverseDctDomain(r: (r + 7), w:(w+7)) = idct( dctDomain(r: (r + 7), w:(w+7)) );
         inverseDctDomain(r: (r + 7), w:(w+7)) = ( idct(idct(mb)')' + 128 );
    end
end
inverseDctDomain = imresize(uint8(inverseDctDomain), [288 352]);

