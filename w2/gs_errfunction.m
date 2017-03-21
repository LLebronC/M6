function [ E ] = gs_errfunction( P0, Xobs ); 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    nobs = size(Xobs,1)/2;
    
    x1 = Xobs(1:nobs);
    x2 =Xobs(nobs+1:end);
    
    x1 = reshape(x1, [2,nobs/2]);  
    x2 = reshape(x2, [2,nobs/2]);
    
    H = reshape(P0(1:9), 3, 3);
    
    xhat = P0(9+1:end);
    xhat = reshape(xhat, [2,size(xhat,1)/2]); 
    xhat = [xhat ; ones(1,size(xhat,2))];
    xhatp = H*xhat;

    E = sum((x1-euclid(xhat)).^2)+sum((x2-euclid(xhatp)).^2);
    
end

