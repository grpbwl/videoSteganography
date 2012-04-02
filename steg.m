for frame=1:15
    [seed] = loadFileYuv('foreman_qcif.yuv', 176, 144, frame);
    [host]= loadFileYuv('bus_cif.yuv',352, 288, frame);
    carrier(frame)=host;

    % hide=double(zeros(1,32));

    k=1;
    n=1;
    for i=1:1:144
        for j=1:1:176
            curr_pix=seed.cdata(i,j,1);
            a(i,j)=idivide(curr_pix,16);
            b(i,j)=rem(curr_pix,16);
            super(i,k)=a(i,j);
            super(i,k+1)=b(i,j);
    %         if i<i*5
    %             if j<j*5
                    hide(n)=double(a(i,j));
                    hide(n+1)=double(b(i,j));
                    n=n+2;    
    %             end
    %         end
            k=k+2;
        end
        k=1;
    end

    rgbImg = host.cdata(:,:,1);

        % Resize to some values that can be 
        scaledImg = rgbImg;

        % Substract 128 and turn into double type matrix
        scaledImg = double(scaledImg);% - 128 ;

        dctDomain = double(zeros(288,352));
        inverseDctDomain = double(zeros(288,352));

    iter=1;
        for r=1:8:288
            for w=1:8:352


                 % Apply 2D DCT
                 mb = dct(scaledImg(r: (r + 7), w:(w+7)));
                 mb = dct(mb')';

                 % put pixel components of seed img into lower DCT triangle for
                 % carrier
                 mb(8,8)=hide(iter);iter=iter+1;             
                 mb(8,7)=hide(iter);iter=iter+1;
                 mb(7,8)=hide(iter);iter=iter+1;
                 mb(6,8)=hide(iter);iter=iter+1;
                 mb(7,7)=hide(iter);iter=iter+1;
                 mb(8,6)=hide(iter);iter=iter+1;
                 mb(8,5)=hide(iter);iter=iter+1;
                 mb(7,6)=hide(iter);iter=iter+1;
                 mb(6,7)=hide(iter);iter=iter+1;
                 mb(5,8)=hide(iter);iter=iter+1;
                 mb(4,8)=hide(iter);iter=iter+1;
                 mb(5,7)=hide(iter);iter=iter+1;
                 mb(6,6)=hide(iter);iter=iter+1;
                 mb(7,5)=hide(iter);iter=iter+1;
                 mb(8,4)=hide(iter);iter=iter+1;
                 mb(8,3)=hide(iter);iter=iter+1;
                 mb(7,4)=hide(iter);iter=iter+1;
                 mb(6,5)=hide(iter);iter=iter+1;
                 mb(5,6)=hide(iter);iter=iter+1;
                 mb(4,7)=hide(iter);iter=iter+1;
                 mb(3,8)=hide(iter);iter=iter+1;
                 mb(2,8)=hide(iter);iter=iter+1;
                 mb(3,7)=hide(iter);iter=iter+1;
                 mb(4,6)=hide(iter);iter=iter+1;
                 mb(5,5)=hide(iter);iter=iter+1;
                 mb(6,4)=hide(iter);iter=iter+1;
                 mb(7,3)=hide(iter);iter=iter+1;
                 mb(8,2)=hide(iter);iter=iter+1;
                 mb(7,2)=hide(iter);iter=iter+1;
                 mb(6,3)=hide(iter);iter=iter+1;
                 mb(3,6)=hide(iter);iter=iter+1;
                 mb(2,7)=hide(iter);iter=iter+1;

                 dctDomain(r: (r + 7), w:(w+7)) = mb;

                 inverseDctDomain(r: (r + 7), w:(w+7)) = ( idct(idct(mb)')');% + 128 );


                 nsi=uint8(inverseDctDomain);
                 nmb = dct(nsi(r: (r + 7), w:(w+7)));
                 nmb = dct(nmb')';           
            end
        end
        newImg=uint8(inverseDctDomain);
        carrier(frame).cdata(:,:,1)=newImg;
        carrier(frame).cdata(:,:,2)=newImg;
        carrier(frame).cdata(:,:,3)=newImg;
end
saveFileYuv(carrier, 'new_carrier.yuv', 'w');