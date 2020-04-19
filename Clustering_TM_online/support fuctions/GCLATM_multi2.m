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
% This is an online implementation of "Clustering based content and color adaptive tone mapping"
% Please refer to the following paper:
% H. Li et al., "Clustering based content and color adaptive tone mapping, 2017" In press
% Computer Vision and Image Understanding
% Please kindly report any suggestions or corrections to xiaohui102788@126.com
%----------------------------------------------------------------------
function L_out2=GCLATM_multi2(L_p, W,L,step,r,MC,denoi, a,cls_num)
 
 images= image2patch(L_p,W,L,step,r);
 
 %% mean substruction
Pmean1=mean(images);
Pmean=repmat(Pmean1, size(images,1), 1);
% images_sub=images-ones(size(images,1),1)*Pmean;
images_sub  =  images-Pmean;
 
%% K-means clustering
% cls_num=100;
[centroids, cls_idx, s_idx, seg, cls_num1]   =  Clustering( images_sub, cls_num );
% [centroids, C_IDX, s_idx, seg, cls_num]   =  Clustering( E_P, Par.ClusterN);
%% projection and compression
t3=0.5;
images_subR=single(zeros(size(images_sub)));
for i = 1:cls_num1
    C_ind    = find(cls_idx==i);                  
    X = images_sub(:,C_ind);
    % PCA basis generation
    [D, mx]   =  getpca(X);   
    D_p=D*X;
     
       %%denosing
    max1=max(abs(D_p));
    max2=repmat(max1*denoi,size(D_p,1),1);
    D_p1=D_p.*(abs(D_p)>max2);
    
    D_mean=Pmean(:,C_ind)*MC;
     D_Compression    = t3*1*(2/pi)*atan(a*D_p1);
    X1=D'*D_Compression+D_mean;
    images_subR(:,C_ind) = X1;
end
%% patch reconstruction 2
L_out2= patch2image(images_subR,W,L,step,r);
