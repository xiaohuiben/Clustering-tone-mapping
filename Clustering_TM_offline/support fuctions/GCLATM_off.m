function L_out=GCLATM_off(L_p, W,L,step,r,col,MC,denoi, a,cd,Pca_D,Centro)
%% patch decomposition 2

Image = cell(col,1);
for i =1:col
%       d=avg_filter( L_p(:,:,i),r);  
  Image{i,1} = image2patch(L_p(:,:,i),W,L,step,r);
 
end

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

Pmean2=repmat(Pmean1, r*r, 1).*MC;
        
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


% [centroids, C_IDX, s_idx, seg, cls_num]   =  Clustering( E_P, Par.ClusterN);
%% projection and compression

images_subR=single(zeros(size(images_sub)));



squareCentro = sum(Centro.^2, 2);
squarePatchs = sum(images_sub.^2, 1);
allDistances = bsxfun(@minus, bsxfun(@plus, squarePatchs, squareCentro), Centro * images_sub); 
[~, assignments] = min(allDistances, [], 1);
% allPCABasis = Pca_D(1:10, :, assignments); 

% tic

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
    images_subR(:,C_ind) = X1;
end

% L_out=patch2image3D(images_subR,W,L,col,step,r);
L_out(:,:,1)     = patch2image(images_subR(1:r*r,:)+Df1+Pmean2,W,L,step,r);
L_out(:,:,2)     = patch2image(images_subR(r*r+1:2*r*r,:)+Df2+Pmean2,W,L,step,r);
L_out(:,:,3)     = patch2image(images_subR(2*r*r+1:3*r*r,:)+Df3+Pmean2,W,L,step,r);