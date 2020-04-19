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




function  [cent, cls_idx, s_idx, seg, cls_num]   =  Clustering( X, cls_num )

b2      =  size(X, 1);
L       =  size(X, 2);
itn     =  12;
m_num   =  200;

P      =  randperm(L);
P2     =  P(1:cls_num);
vec    =  X(:,P2(1:end));


for i = 1 : itn
    
    mse       =  0;
    cent      =  zeros(b2, cls_num);
    cnt       =  zeros(1, cls_num);
    cls_idx   =  zeros(L, 1);
    
    for j = 1 : L
        v     =  X(:, j);
        cb    =  repmat(v,1,cls_num);
        dis   =  sum((vec-cb).^2);
        [val ind]      =   min( dis );
        cent(:, ind)   =   cent(:, ind) + v;
        cnt( ind )     =   cnt( ind ) + 1;
        cls_idx( j )   =   ind;
        mse            =   mse + val;
    end
    
    if (i==itn-3)
        
        [val ind]  =  min( cnt );       % Remove these classes with little samples
        
        while val<m_num            
%             fprintf('Min cls num  = %d\n', val);
            vec(:,ind)    =  [];
            cent(:,ind)   =  [];
            cls_num       =  cls_num - 1;
            cnt(ind)      =  [];

            [val  ind]    =  min(cnt);
        end                
    end
    
    cnt   =  cnt + eps;
    wei   =  repmat(cnt, b2, 1);
    vec   =  cent./wei;    
    mse   =  mse/L/b2;
%     disp( sprintf('clustering %d th loop, mse = %f', i, mse) );
    
end

cent   =  vec;
[s_idx, seg]   =  Proc_cls_idx( cls_idx );
