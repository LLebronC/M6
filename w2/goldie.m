function [ H ] = goldie( Xobs, x, xp, th)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Xobs = The column vector of observed values (x and x')
    
    close all;
    max_inliners = 0;
    best_h = 0;
    
    rep = 0;
    while rep < 100
        rnd = randperm(size(x,2));
        indices = rnd(1:4);

        x1 =  x(:,indices);
        x2 = xp(:,indices);

        H = homography2d(x1, x2);
        
        inliners = sum(sqrt(edist(x, H*xp).^2+edist(inv(H)*x, xp).^2) < th);
        
        if inliners > max_inliners
           max_inliners = inliners;
           rep=0;
           best_h = H;
        elseif inliners >= max_inliners
           rep = rep+1;       
        end
    end
    
    H = best_h;
end


function [dist] = edist(x1, x2)
    dist = sqrt(sum(sqrt(x1 - x2).^2));
end
