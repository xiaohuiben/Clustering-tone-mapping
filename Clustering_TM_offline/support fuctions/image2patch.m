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


function [images, L_N]=image2patch(L_p,W,L,step,r)
% r=7;
% step=3;
% [W,L]=size(L_p);
% images=zeros(r*r,(ceil((W-r)/step)+1)*(ceil((L-r)/step)+1),'single');
% images=zeros(r*r,(ceil((W-r)/step)+1)*(ceil((L-r)/step)+2),'single');
% images=zeros(r*r,(ceil((W-r)/step)+2)*(ceil((L-r)/step)+2),'single');

for i=1:step:W-r+1
       for j=1:step:L-r+1
              images(:,(ceil(i/step)-1)*(ceil((L-r)/step)+1)+ceil(j/step))=reshape(L_p(i:i+r-1,j:j+r-1),r*r,1);
       if (j+step>L-r+1)&&((j+step)-(L-r+1)<step)
           j=L-r+1;
           images(:,(ceil(i/step)-1)*(ceil((L-r)/step)+1)+ceil(j/step+1))=reshape(L_p(i:i+r-1,j:j+r-1),r*r,1);
       end
          
       end
      
        if (i+step>W-r+1)&&((i+step)-(W-r+1)<step)
           i=W-r+1;
            for j=1:step:L-r+1
              images(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step))=reshape(L_p(i:i+r-1,j:j+r-1),r*r,1);
%        if j+step>L-r+1
           if (j+step>L-r+1)&&((j+step)-(L-r+1)<step)
           j=L-r+1;
           images(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step+1))=reshape(L_p(i:i+r-1,j:j+r-1),r*r,1);
       end
            end
        end
%         
%            images(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step))=reshape(L_p(i:i+r-1,j:j+r-1),r*r,1);
  end
%     images(:,find(sum(abs(images))==0))=[];   
    
    L_N=size(images,2);
    
          