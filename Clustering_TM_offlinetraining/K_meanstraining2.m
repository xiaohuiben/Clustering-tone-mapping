
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
% This is a two-scale offline implementation of "Clustering based content and color adaptive tone mapping"
% Please refer to the following paper:
% H. Li et al., "Clustering based content and color adaptive tone mapping, 2017" In press
% Computer Vision and Image Understanding
% Please kindly report any suggestions or corrections to xiaohui102788@126.com
%----------------------------------------------------------------------

clear all;
close all;
addpath(genpath(pwd));

% Set the parameters
step = 5;
r = 7;

folderNames = {'kodim01','kodim02','kodim03','kodim04','kodim05',...
    'kodim06', 'kodim07','kodim08','kodim09','kodim10','kodim11','kodim12','kodim13','kodim14','kodim15','kodim16'};
% folderNames = {'kodim03','kodim02'};
% folderNames = {'Desk'};
X     =  [];
X1 = [];
tic
for i = 1:size(folderNames,2)
    foldname = folderNames{i};
    
    %     Dir =sprintf('D:/20150816系统安装备份/HDR程序/tone mapping/global clustering based/HDRpic/offline/traning/%s.hdr',foldname);
    Dir =sprintf('Kodim/%s.png',foldname);
    hdr = single(imread(Dir));
    
    [W,L,col]=size(hdr);
    L_log=log(hdr*1e6+1);
    
    L_p=L_log/max(L_log(:));
    
    
    %% patch decomposition 2
    
    Image = cell(col,1);
    for ii =1:col
        %       d=avg_filter( L_p(:,:,i),r);
        %   Image{i,1} = image2patch(L_p(:,:,i),W,L,step,r);
        [Image{ii,1},L_N] = image2patch(L_p(:,:,ii),W,L,step,r);
        
    end
    
    
    
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
    
    images_sub = [Image{1,1};Image{2,1};Image{3,1}];
    
    
    X   = [X images_sub];
    %% the second layer
    Pmean1=mean([S_Mean1;S_Mean2;S_Mean3]);
    
    
    
    Pmean2=reshape(Pmean1,[ceil((L-r)/step)+1,ceil((W-r)/step)+1]);
    
    Tmean=Pmean2';
    [W1,L1,col1]=size(Tmean);
    images= image2patch(Tmean,W1,L1,step,r);
    
    %% mean substruction
    Pmean1=mean(images);
    Pmean=repmat(Pmean1, size(images,1), 1);
    images_sub1  =  images-Pmean;
    X1   = [X1 images_sub1];
    
end
% images_sub=images;

%% K-means clustering
cls_num=200;
[centroids, cls_idx, s_idx, seg, cls_num1]   =  Clustering( X, cls_num );
% [centroids, C_IDX, s_idx, seg, cls_num]   =  Clustering( E_P, Par.ClusterN);

%% K-means clustering2
cls_num=100; %% if error appears during training, please decrease the value
[centroids1, cls_idx1, s_idx1, seg1, cls_num2]   =  Clustering( X1, cls_num );
% [centroids, C_IDX, s_idx, seg, cls_num]   =  Clustering( E_P, Par.ClusterN);

images_subR=single(zeros(size(X)));
for j = 1:cls_num1
    C_ind    = find(cls_idx==j);
    X0 = X(:,C_ind);
    % PCA basis generation
    [P, mx]   =  getpca(X0);
    PCA_D(:,:,j)=P;
end

save Centro720cls centroids
save Pca_D720cls PCA_D

images_subR1=single(zeros(size(X1)));
for i = 1:cls_num2
    C_ind    = find(cls_idx1==i);
    X2 = X1(:,C_ind);
    % PCA basis generation
    [P, mx]   =  getpca(X2);
    PCA_D1(:,:,i)=P;
end

save Centro720cls1 centroids1
save Pca_D720cls1 PCA_D1
toc