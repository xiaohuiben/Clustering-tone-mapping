

function hdr1=changesize(hdr,maxSize)

if(~exist('maxSize', 'var'))
    maxSize=512;
end
 if max(size(hdr)) > maxSize
                     ratio = max(size(hdr,1),size(hdr,2))/ maxSize;
%                     hdr = imresize(hdr, 1/ratio,'bicubic');     
                    hdr1 = imresize(hdr, 1/ratio,'bilinear');  
                
   
     else
         hdr1=hdr;
         
  end
% figure(1),imshow(hdr)
% % hdr = imread('C_out.png');
% L_in=double(rgb2gray(hdr));
% 
% L_in=(1/3)*(hdr(:,:,1)+hdr(:,:,2)+hdr(:,:,3)); 
% L_in = 0.2126*hdr(:,:,1) + 0.7152*hdr(:,:,2) + 0.0722*hdr(:,:,3);
% L_in=hdr1;