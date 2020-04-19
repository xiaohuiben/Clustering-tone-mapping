% ========================================================================
% Clustering based content and color adaptive tone mapping
% algorithm Version 1.0
% Copyright(c) 2017, Hui Li, Xixi Jia, and Lei Zhang
% All Rights Reserved.
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is hereby
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
% This is an two-scale offline implementation of "Clustering based content and color adaptive tone mapping"
% Please refer to the following paper:
% H. Li et al., "Clustering based content and color adaptive tone mapping, 2017" In press
% Computer Vision and Image Understanding
% Please kindly report any suggestions or corrections to xiaohui102788@126.com
%----------------------------------------------------------------------

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