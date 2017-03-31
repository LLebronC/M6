function homo = homography2d(p1, p2)
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
        end

        [u,d,v] = svd(a);

        h = reshape(v(:,9),3,3)';

        % Desnormalization
        homo = inv(t2) * h * t1;