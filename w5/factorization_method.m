function [Pproj, Xproj] = factorization_method(x1, x2)
    [norm_x1, T1] = normalise2dpts(x1);
    [norm_x2, T2] = normalise2dpts(x2);
    
    lambda = ones(2, size(x1,2));

    F1 = fundamental_matrix(x1, x1);
    [U, D, V] = svd(F1);
    e1 = V(:,3) / V(3,3);
    for j = 1:size(x1,2)
        lambda(1,j) = (x1(:, j)'*F1*cross(e1, x1(:,j)))/(norm(cross(e1, x1(:,j))).^2*lambda(1, j));
    end
    
    F2 = fundamental_matrix(x2, x1);
    [U, D, V] = svd(F2);
    e2 = V(:,3) / V(3,3);
    for j = 1:size(x2,2)
        lambda(2,j) = (x1(:, j)'*F2*cross(e2, x2(:,j)))/(norm(cross(e2, x2(:,j))).^2*lambda(1, j));
    end

    a = 0;
    dist= Inf;
    keepGoing = true;
    while keepGoing
        resc = true;
        while resc
            lambda_old = lambda;
            
            lambda(1,:) = lambda(1,:) / norm(lambda(1,:));
            lambda(2,:) = lambda(2,:) / norm(lambda(2,:));
            
            for j = 1:size(x1,2)
                lambda(:,j) = lambda(:,j) / norm(lambda(:,j));
            end

            if(norm(lambda - lambda_old) < 0.1)
                resc = false;
            end            
        end
        
        M = zeros(3*2, size(x1,2));
        M(1,:) = lambda(1,:) .* norm_x1(1,:);
        M(2,:) = lambda(1,:) .* norm_x1(2,:);
        M(3,:) = lambda(1,:) .* norm_x1(3,:);
        M(4,:) = lambda(2,:) .* norm_x2(1,:);
        M(5,:) = lambda(2,:) .* norm_x2(2,:);
        M(6,:) = lambda(2,:) .* norm_x2(3,:);
        
        [U,D,V] = svd(M);
        Pm = U * D(:,1:4);
        Xproj = V(:,1:4)';
        
        dist_old = dist;
        dist = 0;
       
        for i=1:2
            if i==1
                 Px = Pm(1:3,:) * Xproj;
                 x = norm_x1;
            else
                 Px = Pm(4:6,:) * Xproj;
                 x = norm_x2;
            end
            
            for j=1:size(x1,2)
                 dist = dist + sum((x(:,j) - Px(:,j)).^2);
            end
        end
        
        if ((abs(dist - dist_old)/dist) < 0.1)
            keepGoing = false;
        end
    end
    
    Pproj(1:3,:) = inv(T1) * Pm(1:3,:);
    Pproj(4:6,:) = inv(T2) * Pm(4:6,:);
end