function A_res = triangulate(x1, x2, P1, P2, window_size)
H=[2/window_size(1) 0 -1; 0 2/window_size(2) -1; 0 0 1];
x1=H*[x1;1];
x2=H*[x2;1];
P1=H*P1;
P2=H*P2;

A=[
    x1(1)*P1(3,:)-P1(1,:);
    x1(2)*P1(3,:)-P1(2,:);
    x2(1)*P2(3,:)-P2(1,:);
    x2(2)*P2(3,:)-P2(2,:)];
%     A(1,:) = A(1,:)/norm(A(1,:));
%     A(2,:) = A(2,:)/norm(A(2,:));
%     A(3,:) = A(3,:)/norm(A(3,:));
%     A(4,:) = A(4,:)/norm(A(4,:));

    [U D V] = svd(A);
    A_res = V(:,end);
%     A_res = A_res / A_res(4);