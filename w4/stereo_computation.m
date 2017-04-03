function [depth_map] = stereo_computation(leftimage, rightimage, minimum_disparity, maximum_disparity, window_size, matching_cost)
    image_size=size(leftimage);
    
    %Pixels to center of the window
    window_size=floor(window_size./2);
    %depht map
    depth_map=zeros(image_size(1),image_size(2),1);
    %image loop
    for counti=window_size(1)+1:image_size(1)-window_size(1) 
        for countj=window_size(2)+1:image_size(2)-window_size(2)  %window_size(2)
            leftwindow=leftimage(counti-window_size(1):counti+window_size(1), countj-window_size(2):countj+window_size(2));        
            countdisp=0;
            if strcmp(matching_cost,'SSD')
                vdis=Inf;    
            elseif strcmp(matching_cost,'NCC')
                vdis=-Inf;
            end
            
            
            for disparity =minimum_disparity:maximum_disparity
                downposi=counti-window_size(1);
                upposi=counti+window_size(1);
                downposj=countj-window_size(2)+disparity;
                upposj=countj+window_size(2)+disparity;
                if (downposi>0 && downposj>0 && upposi<image_size(1) && upposj<image_size(2))
                    rightwindow=rightimage(downposi:upposi,downposj:upposj);
                    if strcmp(matching_cost,'SSD')
                        aux_vdis=sum(sum((leftwindow - rightwindow).^2));
                        %aux_vdis=corr2(leftwindow,rightwindow);
                        if(aux_vdis<vdis)
                            vdis=aux_vdis;
                            depth_map(counti,countj)=countdisp;
                        end
                    elseif strcmp(matching_cost,'NCC')
                        aux_vdis=((leftwindow - mean2(leftwindow)).*(rightwindow - mean2(rightwindow)))/...
                            (sqrt(sum(sum((leftwindow - mean2(leftwindow)).^2)))*sqrt(sum(sum((rightwindow - mean2(rightwindow)).^2))));
                        if(aux_vdis>vdis)
                            vdis=aux_vdis;
                            depth_map(counti,countj)=countdisp;
                        end
                    end
                end
                countdisp=countdisp+1;
            end
        end
    end
    
end