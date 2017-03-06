function [ H ] = get_metric_rect( l1, m1, l2, m2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%     A = [[l1(1)*m1(1), l1(1)*m1(2)+l1(2)*m1(1)]; [l2(1)*m2(1), l2(1)*m2(2)+l2(2)*m2(1)]];
%     B = [[-l1(2)*m1(2)];[-l2(2)*m2(2)]];
    A = [[l1(1)*m1(1), l1(1)*m1(2)+l1(2)*m1(1), l1(2)*m1(2)]; [l2(1)*m2(1), l2(1)*m2(2)+l2(2)*m2(1), l2(2)*m2(2)]];
    
    [U,D,V] = svd(A);
    x = V(:,3);
    
    S = [[x(1) x(2)];[x(2) x(3)]];
    
    K = chol(S, 'upper');

    H = eye(3);
    H(1:2,1:2) = inv(K);
end

