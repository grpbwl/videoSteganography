F = 60;
extracted=newFileYuv(176,144);
ndctDomain = double(zeros(288,352));
ninverseDctDomain = double(zeros(288,352));
unhide=double(zeros(1,50688));
tic;
for frame=1:F
    [carrier]= loadFileYuv('new_carrier.yuv',352, 288, frame);    
    scaledImg = double(carrier.cdata(:,:,1));
    
        iter=1;
        for r=1:8:288
            for w=1:8:352

                 % Apply 2D DCT
                 nmb = dct(scaledImg(r: (r + 7), w:(w+7)));
                 nmb = dct(nmb')';

                 % put pixel components of seed img into lower DCT triangle for
                 % carrier
                 unhide(iter)=nmb(8,8);iter=iter+1;             
                 unhide(iter)=nmb(8,7);iter=iter+1;            
                 unhide(iter)=nmb(7,8);iter=iter+1;
                 unhide(iter)=nmb(6,8);iter=iter+1;
                 unhide(iter)=nmb(7,7);iter=iter+1;
                 unhide(iter)=nmb(8,6);iter=iter+1;
                 unhide(iter)=nmb(8,5);iter=iter+1;
                 unhide(iter)=nmb(7,7);iter=iter+1;
                 unhide(iter)=nmb(6,7);iter=iter+1;
                 unhide(iter)=nmb(5,8);iter=iter+1; 
                 unhide(iter)=nmb(4,8);iter=iter+1;
                 unhide(iter)=nmb(5,7);iter=iter+1;
                 unhide(iter)=nmb(6,6);iter=iter+1;
                 unhide(iter)=nmb(7,5);iter=iter+1;
                 unhide(iter)=nmb(8,4);iter=iter+1;
                 unhide(iter)=nmb(8,3);iter=iter+1;
                 unhide(iter)=nmb(7,4);iter=iter+1;
                 unhide(iter)=nmb(6,5);iter=iter+1;
                 unhide(iter)=nmb(5,6);iter=iter+1;
                 unhide(iter)=nmb(4,7);iter=iter+1;
                 unhide(iter)=nmb(3,8);iter=iter+1;
                 unhide(iter)=nmb(2,8);iter=iter+1;
                 unhide(iter)=nmb(3,7);iter=iter+1;
                 unhide(iter)=nmb(4,6);iter=iter+1;
                 unhide(iter)=nmb(5,5);iter=iter+1;
                 unhide(iter)=nmb(6,4);iter=iter+1;
                 unhide(iter)=nmb(7,3);iter=iter+1;
                 unhide(iter)=nmb(8,2);iter=iter+1;
                 unhide(iter)=nmb(7,2);iter=iter+1;
                 unhide(iter)=nmb(6,3);iter=iter+1;
                 unhide(iter)=nmb(3,6);iter=iter+1;
                 unhide(iter)=nmb(2,7);iter=iter+1;
                 ninverseDctDomain(r: (r + 7), w:(w+7)) = ( idct(idct(nmb)')');% + 128 );            
            end
        end
        unhide=uint8(unhide);

    new_im=uint8(zeros(144,176));
    k=1;
    for i=1:1:144
        for j=1:1:176
            new_im(i,j)=unhide(k)*16+unhide(k+1);
            k=k+2;
        end
    end
    %new_im=imfilter(new_im,fspecial('gaussian',176));

    extracted(frame).cdata(:,:,1)=new_im;
    extracted(frame).cdata(:,:,2)=new_im;
    extracted(frame).cdata(:,:,3)=new_im;
end
toc;
saveFileYuv(extracted, 'extracted.yuv', 'w');