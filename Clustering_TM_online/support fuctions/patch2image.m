
function A1=patch2image(I1,W,L,step,r)

% f1=zeros(W,L);
% c1=zeros(W,L);
% A1=zeros(W,L,'single');
f1=zeros(W,L, 'single');
c1=zeros(W,L, 'single');
A1=zeros(W,L, 'single');
% f1=zeros(W,L,col);
% c1=zeros(W,L);
for i=1:step:W-r+1
    for j=1:step:L-r+1
        e1=reshape(I1(:,(ceil(i/step)-1)*(ceil((L-r)/step)+1)+ceil(j/step)),r,r);
        f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
        c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
        %           if j+step>L-r+1
        if (j+step>L-r+1)&&((j+step)-(L-r+1)<step)
            j=L-r+1;
            e1=reshape(I1(:,(ceil(i/step)-1)*(ceil((L-r)/step)+1)+ceil(j/step+1)),r,r);
            f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
            c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
        end
    end
    
    %         if i+step>W-r+1
    if (i+step>W-r+1)&&((i+step)-(W-r+1)<step)
        i=W-r+1;
        for j=1:step:L-r+1
            e1=reshape(I1(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step)),r,r);
            f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
            c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
            %             if j+step>L-r+1
            if (j+step>L-r+1)&&((j+step)-(L-r+1)<step)
                j=L-r+1;
                e1=reshape(I1(:,(ceil(i/step))*(ceil((L-r)/step)+1)+ceil(j/step+1)),r,r);
                f1(i:i+r-1,j:j+r-1)=f1(i:i+r-1,j:j+r-1)+e1;
                c1(i:i+r-1,j:j+r-1)= c1(i:i+r-1,j:j+r-1)+1;
            end
        end
    end
    
end
A1=f1./(c1+eps);