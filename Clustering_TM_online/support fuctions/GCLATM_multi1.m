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
function [L_out,Tmean,L_N]=GCLATM_multi1(L_p, W,L,step,r,col,MC,denoi, a,cd,cls_num)


%% patch decomposition 2

Image = cell(col,1);
for i =1:col
    %       d=avg_filter( L_p(:,:,i),r);
    [Image{i,1},L_N] = image2patch(L_p(:,:,i),W,L,step,r);
    
end

% %% PCA Reduction
%    [D, mx]   =  getpca( Image{1,1});

% imshow(Tmean);
%% The mean of each channel
S_Mean1=mean(Image{1,1});
S_Mean11=repmat(S_Mean1, r*r, 1);

Image{1,1}=Image{1,1}-S_Mean11;
S_Mean2=mean(Image{2,1});
S_Mean22=repmat(S_Mean2, r*r, 1);
Image{2,1}=Image{2,1}-S_Mean22;
S_Mean3=mean(Image{3,1});
S_Mean33=repmat(S_Mean3, r*r, 1);
Image{3,1}=Image{3,1}-S_Mean33;

Pmean1=mean([S_Mean1;S_Mean2;S_Mean3]);
Pmean2=reshape(Pmean1,[ceil((L-r)/step)+1,ceil((W-r)/step)+1]);
Tmean=Pmean2';

%% mean substruction
t2=0.6;

Df1=S_Mean1-Pmean1;
Df1=repmat(Df1, r*r, 1)*t2;
Df1=1*(2/pi)*atan(cd*Df1);
Df2=S_Mean2-Pmean1;
Df2=repmat(Df2, r*r, 1)*t2;
Df2=1*(2/pi)*atan(cd*Df2);
Df3=S_Mean3-Pmean1;
Df3=repmat(Df3, r*r, 1)*t2;
Df3=1*(2/pi)*atan(cd*Df3);

% Pmean2=reshape(Pmean1,[ceil((W-r)/step)+1,ceil((L-r)/step)+1]);

images_sub  = [Image{1,1};Image{2,1};Image{3,1}];


%% K-means clustering
% cls_num=200;
[centroids, cls_idx, s_idx, seg, cls_num1]   =  Clustering( images_sub, cls_num );
% [centroids, C_IDX, s_idx, seg, cls_num]   =  Clustering( E_P, Par.ClusterN);
%% projection and compression
t3=0.8;
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
    
    D_Compression    = t3*1*(2/pi)*atan(a*D_p1);
    X1=D'*D_Compression;
    
    images_subR(:,C_ind) = X1;
end

% L_out=patch2image3D(images_subR,W,L,col,step,r);
L_out(:,:,1)     = patch2image(images_subR(1:r*r,:)+Df1,W,L,step,r);
L_out(:,:,2)     = patch2image(images_subR(r*r+1:2*r*r,:)+Df2,W,L,step,r);
L_out(:,:,3)     = patch2image(images_subR(2*r*r+1:3*r*r,:)+Df3,W,L,step,r);