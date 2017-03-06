function [ H ] = get_metric_rect( l1, m1, l2, m2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    A = [[l1(1)*m1(1), (l1(1)*m1(2)+l1(2)*m1(1))/2]; [l2(1)*m2(1), (l2(1)*m2(2)+l2(2)*m2(1))/2]];
    B = [[-l1(2)*m1(2)];[-l2(2)*m2(2)]];

    x = A\B;
    
    S = [[x(1) x(2)];[x(2) 1]];
    
    [U,D,V] = svd(S);
    sqrtD = sqrt(D);
    A = transpose(U)*sqrtD;
    A = A*V;
    H2 = eye(3);
    H2(1:2,1:2) = A;
    H2(1,1) = abs(H2(1,1));
    H2(2,2) = abs(H2(2,2));

    H = H2';
end

