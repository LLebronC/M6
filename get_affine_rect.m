function [ H ] = get_affine_rect( l1, l2 , l3, l4)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    v1 = cross(l1,l2);
    v2 = cross(l3,l4);
    l = cross(v1,v2);

    H = [1 0 0; 0 1 0; l(1)/l(3) l(2)/l(3) l(3)/l(3)];
end

