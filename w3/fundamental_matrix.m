function F = fundamental_matrix(p1, p2)

        [p1,t1]=normalise2dpts(p1);
        [p2,t2]=normalise2dpts(p2);
         
        u1 = p1(1,:); 
        v1 = p1(2,:);
        u2 = p2(1,:);
        v2 = p2(2,:);

        % Fundamental matrix
        W = [];
        for i=1:length(u1)
            W = [W; u1(i)*u2(i) v1(i)*u2(i) u2(i) u1(i)*v2(i) ...
                    v1(i)*v2(i) v2(i)       u1(i) v1(i) 1];
        end
        
        % F is the last column of V.
        [u,d,v] = svd(W);
        F_rank3 = reshape(v(:,9),3,3)'; %Compose fundamental matrix F_rank3

        [u,d,v] = svd(F_rank3); % Compute the SVD of fundamental matrix F_rank3 =UDVT
        d(3,3) = 0; %Remove last singular value of D to create ?
        
        F = u*d*v'; % Re-compute matrix F = U ? VT (rank 2)
        % Desnormalization
        F = inv(t2) * F * t1;