
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
clc;
warning off all;
addpath(genpath(pwd));

%% Load tranform dictionary
Pca_D1=load('Pca_D720cls.mat');
Pca_D=single(Pca_D1.PCA_D);

Centro1=load ('Centro720cls.mat');
Centro=single(Centro1.centroids);
Centro=Centro';

Pca_D2t=load('Pca_D720cls1.mat');
Pca_D2=single(Pca_D2t.PCA_D1);

Centro2=load ('Centro720cls1.mat');
Centro2t=single(Centro2.centroids1);
Centro2=Centro2t';


%% Load HDR image and pre-process

hdr = single(hdrread('11.hdr'));

%% adjust size and initialization
% maxSize=1024;
% hdr=changesize(hdr,maxSize);
L_log=log(hdr*1e6+1);  
L_p=L_log/max(L_log(:)); 

%% Parameter setting

MC=0.8;%% luminance
a1=6;%% detail 
cd=4; %% color saturation
denoi=0.1; %% remove noise level
r=7;
step=2;
r1=7;
step1=2;
a2=6;
%% patch decomposition and tone mapping

[W,L,col]=size(L_p);
L_out=zeros(W,L,col);

[images_subR1,Tmean1,L_N]=GCLATM_off21(L_p, W,L,step,r,col,MC,denoi, a1,cd,Pca_D,Centro);
[W1,L1,col1]=size(Tmean1);

images_subR2=GCLATM_off22(Tmean1, W1,L1,step1,r1,col1,MC,denoi, a2,Pca_D2,Centro2);

images_subR22=images_subR2';
images_subR3=reshape(images_subR22,[1,L_N]);
images_subR3=repmat(images_subR3, r*r, 1);
images_subR4=patch2image(images_subR3,W,L,step,r);

for ii=1:3
L_out(:,:,ii)=images_subR1(:,:,ii)+images_subR4;
end

%% cutting pixels
maxL=MaxQuart(L_out(:),0.99);
minL=MaxQuart(L_out(:),0.01);
L_out(L_out>maxL)=maxL;  
L_out(L_out<minL)=minL;  
%% linearly streching to 0-1
C_out=mat2gray(L_out);  
imshow(C_out);


