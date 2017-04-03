function X_res = triangulate_inhomogeneous(x1, x2, P1, P2, window_size)
    H=[2/window_size(1) 0 -1; 0 2/window_size(2) -1; 0 0 1];
    x1=H*homog(x1);
    x2=H*homog(x2);
    P1=H*P1;
    P2=H*P2;

    A=[
        x1(1)*P1(3,:)-P1(1,:);
        x1(2)*P1(3,:)-P1(2,:);
        x2(1)*P2(3,:)-P2(1,:);
        x2(2)*P2(3,:)-P2(2,:)
    ];
    A2=A(:,1:3);

    [U D V] = svd(A2);
    a42=U'*A(:,4);
    Y=zeros(size(D,2),1);
    for i=1:size(D,2)
        Y(i,1)= (-a42(i))/D(i,i);
    end
    X=V*Y;
    X_res = homog(X);