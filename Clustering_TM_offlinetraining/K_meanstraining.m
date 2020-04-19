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
% folderNames = {'kodim03'};
X     =  [];
X0 = [];

for i = 1:size(folderNames,2)
    foldname = folderNames{i};
    
    Dir =sprintf('Kodim/%s.png',foldname);
    %     hdr = single(hdrimread(Dir));
    hdr = single(imread(Dir));
    
    [W,L,col]=size(hdr);
    L_log=log(hdr*1e6+1);
    L_p=L_log/max(L_log(:));
    
    
    %% patch decomposition 2
    
    Image = cell(col,1);
    for ii =1:col
        %       d=avg_filter( L_p(:,:,i),r);
        Image{ii,1} = image2patch(L_p(:,:,ii),W,L,step,r);
        
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
end
% images_sub=images;

%% K-means clustering
cls_num=200;
[centroids, cls_idx, s_idx, seg, cls_num1]   =  Clustering( X, cls_num );
% [centroids, C_IDX, s_idx, seg, cls_num]   =  Clustering( E_P, Par.ClusterN);


images_subR=single(zeros(size(X)));
for j = 1:cls_num1
    C_ind    = find(cls_idx==j);
    X0 = X(:,C_ind);
    % PCA basis generation
    [P, S0]   =  getpca(X0);
    PCA_D(:,:,j)=P;
    S1(:,i)=S0;
end

% save Centro720cls centroids
% save Pca_D720cls PCA_D
% save  Singu71 S1

save Centro_w71 centroids
save Pca_D_w71 PCA_D
save  Singu71 S1
