
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



function A1=patch2image(I1,W,L,step,r)

% f1=zeros(W,L);
% c1=zeros(W,L);
% A1=zeros(W,L,'single');
f1=zeros(W,L, 'single');
c1=zeros(W,L, 'single');
A1=zeros(W,L, 'single');
% f1=zeros(W,L,col);
% c1=zeros(W,L);
 for i=1:step:W-r+1
       for j=1:step:L-r+1
          e1=reshape(I1(:,(ceil(i/step)-1)*(ceil((L-r)/step)+1)+ceil(j/step)),r,r);
          f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
          c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
%           if j+step>L-r+1
              if (j+step>L-r+1)&&((j+step)-(L-r+1)<step)
           j=L-r+1;
           e1=reshape(I1(:,(ceil(i/step)-1)*(ceil((L-r)/step)+1)+ceil(j/step+1)),r,r);
           f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
           c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
          end
       end
       
%         if i+step>W-r+1
     if (i+step>W-r+1)&&((i+step)-(W-r+1)<step)
           i=W-r+1;
            for j=1:step:L-r+1           
           e1=reshape(I1(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step)),r,r);
           f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
           c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
%             if j+step>L-r+1
                if (j+step>L-r+1)&&((j+step)-(L-r+1)<step)
           j=L-r+1;
           e1=reshape(I1(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step+1)),r,r);
           f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
           c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
           end
            end
        end 
       
 end
 A1=f1./(c1+eps);