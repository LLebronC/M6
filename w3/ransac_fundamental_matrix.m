function [F, idx_inliers] = ransac_fundamental_matrix(x1, x2, th)

[Ncoords, Npoints] = size(x1);
max_it = 1000;
% ransac
it = 0;
best_inliers = [];
while it < max_it
    
    points = randomsample(Npoints, 8);
    F = fundamental_matrix(x1(:,points), x2(:,points)); % ToDo: you have to create this function
    inliers = compute_inliers(F, x1, x2, th);
    
    % test if it is the best model so far
    if length(inliers) > length(best_inliers)
        best_inliers = inliers;
    end    
    
    % update estimate of max_it (the number of trials) to ensure we pick, 
    % with probability p, an initial data set with no outliers
%     fracinliers =  length(inliers)/Npoints;
%     pNoOutliers = 1 -  fracinliers^4;
%     pNoOutliers = max(eps, pNoOutliers);  % avoid division by -Inf
%     pNoOutliers = min(1-eps, pNoOutliers);% avoid division by 0
%     p=0.99;
%     max_it = log(1-p)/log(pNoOutliers);

    it = it + 1;
end

% compute F from all the inliers
F = fundamental_matrix(x1(:,best_inliers), x2(:,best_inliers));
idx_inliers = best_inliers;

function idx_inliers = compute_inliers(F, x1, x2, th)
    % Check that F is invertible
%     if abs(log(cond(F))) > 15
%         idx_inliers = [];
%         return
%     end       
    % approximation of the geometric error: Sampson distance
    d = sampson_distance(F, x1, x2);
    idx_inliers = find(d < th.^2);

function xn = normalise(x)    
    xn = x ./ repmat(x(end,:), size(x,1), 1);
    
function disx=sampson_distance(F,X,Y)
    points=find(X(3,:)~=0);
    X(1:2,points)=[X(1,points)./X(3,points);X(2,points)./X(3,points);];
    X=X(1:2,:);
    X(3,:) = 1;
    
    points=find(Y(3,:)~=0);
    Y(1:2,points)=[Y(1,points)./Y(3,points);Y(2,points)./Y(3,points);];
    Y=Y(1:2,:);
    Y(3,:) = 1;
    
    size_x=size(X,2);
    
    upsampsdis=zeros(1,size_x);
    
    for i =1:size_x
        upsampsdis(i)= Y(:,i)'*F*X(:,i);
    end
    
    FX = F*X;
    FY = F'*Y;

    % Evaluate distances
    disx =  upsampsdis.^2 ./ (FX(1,:).^2 + FX(2,:).^2 + FY(1,:).^2 + FY(2,:).^2);

    
function item = randomsample(npts, n)
	a = [1:npts]; 
    item = zeros(1,n);    
    for i = 1:n
	  % Generate random value in the appropriate range 
	  r = ceil((npts-i+1).*rand);
	  item(i) = a(r);       % Select the rth element from the list
	  a(r)    = a(end-i+1); % Overwrite selected element
    end                       % ... and repeat