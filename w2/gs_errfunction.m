function [ E ] = gs_errfunction( P0, Xobs ); 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    H = reshape(P0(1:9), 3, 3);
    
    x1 = Xobs(1:size(Xobs,1)/2);
    x1 = reshape(x1, [2,size(x1,1)/2]);
    
    x2 =Xobs(size(Xobs,1)/2+1:end);
    x2 = reshape(x2, [2,size(x2,1)/2]);
    
    xhat = P0(9+1:end);
    xhat = reshape(xhat, [2,size(xhat,1)/2]); % from nx1 to 2x(n/2)
    xhat = [xhat ; ones(1,size(xhat,2))]; % from euclidean to homogeneous
    xhatp = H*xhat;
    
    d1 = sum((x1-euclid(xhat)).^2);
    d2 = sum((x2-euclid(xhatp)).^2);
    E = d1+d2;
    
    
%     % x
%     xx = reshape(Xobs, 2, length(Xobs)/2);
%     
%     x = xx(:, 1:length(xx)/2);
%     xp = xx(:, length(xx)/2+1:length(xx));
%     x_hat = reshape(P0(10:length(P0)),2,(length(P0)-9)/2);
%     x_hat_hom = [x_hat; ones(1, length(x_hat))];
%     x_hat_p_hom  = H*x_hat_hom;
%     x_hat_p = [x_hat_p_hom(1, :)./x_hat_p_hom(3,:); x_hat_p_hom(2, :)./x_hat_p_hom(3,:)];
%     dist_left = sum((x-x_hat).^2,1);
%     dist_right = sum((xp - x_hat_p).^2,1);
%     E = [dist_left dist_right];
end

