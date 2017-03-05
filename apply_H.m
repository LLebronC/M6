function I2 = apply_H(I, H)

%in->out
%     I1=im2double(I);
%     for i=1:size(I,1)
%         for j=1:size(I,2)
%             v1 = [j;i;1];
%             v2 = H*v1;
%             v3 =v2/v2(3,1);
%             if (v3(1,1) <0 || v3(2,1)<0 || v3(3,1)<0)
%                continue;
%             else     
%                 I2(round(1+v3(2,1)),round(1+v3(1,1)),:)=I1(i,j,:);
%             end
%         end
%     end


%out->in
    I1=im2double(I);
%     H=inv(H);
    controlpoints=[];
    for i =[1 size(I1,1)]
        for j =[1 size(I1,2)]
            v1 = [j;i;1];
            v2 = H*v1;
            v3 =v2/v2(3,1); 
            controlpoints=[controlpoints;[round(1+v3(2,1)),round(1+v3(1,1))]];
        end
    end
    minx=min(controlpoints(:,1));
    maxx=max(controlpoints(:,1));
    miny=min(controlpoints(:,2));
    maxy=max(controlpoints(:,2));
    I2=double(zeros(maxx-minx+1,maxy-miny+1,size(I1,3)));
    for i=1:size(I2,1)
        for j=1:size(I2,2)
            v1 = [j+miny;i+minx;1];
            v2 = H\v1;
            v3 =v2/v2(3,1);
            x=round(1+v3(2,1));
            y=round(1+v3(1,1));
            if x>0 && x<size(I1,1)&& y>0 && y<size(I1,2)  
                I2(i,j,:)=I1(x,y,:);
            end
        end
    end
    
    I2 = I2*255;
%easy way
% A=transpose(H);
% t = maketform('affine',A);
% % t = maketform('projective',A);
% I2 = imtransform(I,t);
end