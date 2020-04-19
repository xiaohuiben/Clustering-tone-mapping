

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

