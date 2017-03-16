function homo = homography2d(p1, p2)
        %TODO: ellos normalizavan antes quizas tambien extraer la transformacion
        %del final
        [p1,t1]=normalise2dpts(p1);
        [p2,t2]=normalise2dpts(p2);
         
         
        x2 = p2(1,:);
        y2 = p2(2,:);
        z2 = p2(3,:);

        % Ah = 0
        a = [];
        for i=1:size(p1,2)
            a = [a; zeros(3,1)'     -z2(i)*p1(:,i)'   y2(i)*p1(:,i)'; ...
                    z2(i)*p1(:,i)'   zeros(3,1)'     -x2(i)*p1(:,i)'];
                   %-y2*p1     x2*p1      zeros(1,3)
        end

        % Obtain the SVD of A. The unit singular vector corresponding to the
        % smallest singular value is the solucion h. A = UDV' with D diagonal with
        % positive entries, arranged in descending order down the diagonal, then h
        % is the last column of V.
        [u,d,v] = svd(a);

        h = reshape(v(:,9),3,3)';

        % Desnormalization
        homo = inv(t2) * h * t1;
         %TODO: falta comprovar la homography referencia: https://es.mathworks.com/matlabcentral/answers/26141-homography-matrix