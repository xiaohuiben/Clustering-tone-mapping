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
% This is a single-scale offline implementation of "Clustering based content and color adaptive tone mapping"
% Please refer to the following paper:
% H. Li et al., "Clustering based content and color adaptive tone mapping, 2017" In press
% Computer Vision and Image Understanding
% Please kindly report any suggestions or corrections to xiaohui102788@126.com
%----------------------------------------------------------------------


clear all;  
close all;
warning off all;
addpath(genpath(pwd));

%% Load tranform dictionary
Pca_D1=load('Pca_D720cls.mat');
Pca_D=single(Pca_D1.PCA_D);

Centro1=load ('Centro720cls.mat');
Centro=single(Centro1.centroids);
Centro=Centro';

%% Load HDR image and pre-process

hdr = single(hdrread('11.hdr'));

%% adjust size and initialization
% maxSize=1024;
% L_in=changesize(hdr,maxSize);

L_in=hdr;
L_log=log(L_in*1e6+1);  
L_p=L_log/max(L_log(:)); 

%% Parameter setting
MC=0.8;%% luminance
a=6; %% detail 
cd=4; %% color saturation
denoi=0.1; %% remove noise level
r=7;
step=2;

%% patch decomposition and tone mapping

[W,L,col]=size(L_p);
L_out=GCLATM_off(L_p, W,L,step,r,col,MC,denoi,a, cd,Pca_D,Centro);

%% cutting pixels
maxL=MaxQuart(L_out(:),0.99);
minL=MaxQuart(L_out(:),0.01);
L_out(L_out>maxL)=maxL;  
L_out(L_out<minL)=minL;  
%% linearly streching to 0-1
C_out=mat2gray(L_out);  
imshow(C_out);

