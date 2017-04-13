function [Xproj, Pproj] = factorization_method(x1,x2)
    %normalizacion
    x_norm=[];
    [aux_x, Hs1] = normalise2dpts(x1);
    x_norm=[x_norm;aux_x];
    [aux_x, Hs2] = normalise2dpts(x2);
    x_norm=[x_norm;aux_x];   
    lambda = ones(2, size(x1, 2));
    
    %inicializar condicion
    d_old = 0.000000000000001; 
    d = 0.0000000000000000001;

    while double(abs(d - d_old)/d) > 0.1
        %normalizacion
        for loop = 1:2
            for i = 1:size(lambda,1)
                lambda(i,:) = lambda(i,:)/norm(lambda(i,:));
            end
            for i = 1:size(lambda,2)
                lambda(:,i) = lambda(:,i)/norm(lambda(:,i));
            end
        end
        %matriz lambda 3m,n
        lambda = [lambda(1, :); lambda(1, :); lambda(1, :); lambda(2, :); lambda(2, :); lambda(2, :)];
        d_old = d;
        %uni cada lambdai,j*xi,j
        M = lambda .* x_norm;
 
        [U, D, V] = svd(M);

        Pproj = U * D(:, 1:4);
        Xproj = V(:, 1:4)';
        d = sum(sum((x_norm - Pproj * Xproj).^2));
        %primera vista
        P1 = Pproj(1:3,:);
        px1 = P1 * Xproj;
        
        %segunda vista
        P2 = Pproj(4:6,:);
        px2 = P2 * Xproj;
        
        %recalculo de lambda
        lambda = [px1(3,:); px2(3,:)];
        
        %distancia
        
    end
    Pproj = [Hs1\P1; Hs2\P2];