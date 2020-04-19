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

function L_out=GCLATM_off22(L_p, W,L,step,r,col,MC,denoi, a,Pca_D,Centro)

%% patch decomposition 2


%% The mean of each channel

 images= image2patch(L_p,W,L,step,r);
 
 %% mean substruction
Pmean1=mean(images);
Pmean=repmat(Pmean1, size(images,1), 1);

images_sub  =  images-Pmean;

%% projection and compression

images_subR=single(zeros(size(images_sub)));

squareCentro = sum(Centro.^2, 2);
squarePatchs = sum(images_sub.^2, 1);
allDistances = bsxfun(@minus, bsxfun(@plus, squarePatchs, squareCentro), Centro * images_sub); 
[~, assignments] = min(allDistances, [], 1);


for i=1:max(assignments)
    
    C_ind    = find(assignments==i);                  
    X = images_sub(:,C_ind);
    % PCA projection
    D= Pca_D(:, :, i);  
    D_p= D*X;
    %%denosing
    max1=max(abs(D_p));
    max2=repmat(max1*denoi,size(D_p,1),1);
    D_p1=D_p.*(abs(D_p)>max2);
    D_Compression    = (1.6/pi)*atan(a*D_p1);
      %%reconstruction
    X1=D'*D_Compression;
    D_mean= MC*Pmean(:,C_ind);
    images_subR(:,C_ind) = X1+D_mean;
end


L_out= patch2image(images_subR,W,L,step,r);