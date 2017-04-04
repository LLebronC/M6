function cost=bilateral_cost(leftwindow,rightwindow)
%locate the point of interest and make a grid of the distance between p and
%q
if mod(size(leftwindow,1),2)
   point = ceil(size(leftwindow,1)/2);
   [p, q] = meshgrid(-point+1:point-1,-point+1:point-1);
else 
   point = size(leftwindow,1)/2;
   [p, q] = meshgrid(-point:point,-point:point);
end


%matrix of distance to computerd e
matrix_e = sqrt(p.^2+q.^2);
%use in the original experiment
T=40;
gamma_c=5;
gamma_p=17.5;

cost=sum(sum(bilateral_weight(leftwindow,point,matrix_e,gamma_c,gamma_p)*bilateral_weight(rightwindow,point,matrix_e,gamma_c,gamma_p)*bilateral_e(leftwindow,rightwindow,T)));
cost=cost/(sum(sum(bilateral_weight(leftwindow,point,matrix_e,gamma_c,gamma_p)*bilateral_weight(rightwindow,point,matrix_e,gamma_c,gamma_p))));