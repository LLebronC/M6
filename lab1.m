close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lab 1: Image rectification


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% 1. Applying image transformations
% 
% % ToDo: create the function  "apply_H" that gets as input a homography and
% % an image and returns the image transformed by the homography.
% % At some point you will need to interpolate the image values at some points,
% % you may use the Matlab function "interp2" for that.
% 
% 
% %% 1.1. Similarities
% I=imread('Data/0005_s.png'); % we have to be in the proper folder
% 
% % ToDo: generate a matrix H which produces a similarity transformation
% % theta=pi/4;
% % H=[[cos(theta) -sin(theta) 10];[sin(theta) cos(theta) 20];[0 0 1]];
% % I2 = apply_H(I, H);
% % figure; imshow(I); figure; imshow(I2);
% 
% 
% %% 1.2. Affinities
% 
% % ToDo: generate a matrix H which produces an affine transformation
% 
% theta=pi/4;
% H=[[cos(theta) -sin(theta) 10];[sin(theta) cos(theta) 20];[0 0 1]];
% % I2 = apply_H(I, H);
% % figure; imshow(I); figure; imshow(I2);
% 
% % ToDo: decompose the affinity in four transformations: two
% % rotations, a scale, and a translation
% [U,D,V] = svd(H(1:2,1:2));
% Ro=U*V';
% Rphi=V';
% Rnphi=V;
% transalation=[1 0 H(1,3);
%               0 1 H(2,3);
%               0  0  1];
% % ToDo: verify that the product of the four previous transformations
% % produces the same matrix H as above
% % A=Ro*Rnphi*D*Rphi;
% % 'H==A'
% % H(1:2,1:2)-A
% % ToDo: verify that the proper sequence of the four previous
% % transformations over the image I produces the same image I2 as before
% IR1 = apply_H(I, [Rphi(1,1) Rphi(1,2) 0;
%                   Rphi(2,1) Rphi(2,2) 0;
%                   0  0 1] );
% ID = apply_H(IR1, [D(1,1) 0 0;
%                   0 D(2,2) 0;
%                   0  0 1]);
% IR2 = apply_H(ID, [Rnphi(1,1) Rnphi(1,2) 0;
%                   Rnphi(2,1) Rnphi(2,2) 0;
%                   0  0 1]);
% IR3 = apply_H(IR2, [Ro(1,1) Ro(1,2) 0;
%                   Ro(2,1) Ro(2,2) 0;
%                   0  0 1]);
% IT = apply_H(IR3, transalation);
% figure; imshow(I); figure; imshow(IR3);
% 
% return
% %% 1.3 Projective transformations (homographies)
% 
% % ToDo: generate a matrix H which produces a projective transformation
% % H=[ 0.9638   -0.0960   52.5754;
% %  0.2449    1.3808  -17.0081;
% % -0.0001    0.0013    1.0000];
% % I2 = apply_H(I, H);
% % figure; imshow(I); figure; imshow(I2);
% % return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Affine Rectification


% choose the image points
I=imread('Data/0000_s.png');
A = load('Data/0000_s_info_lines.txt');

% indices of lines
i = 424;
p1 = [A(i,1) A(i,2) 1]';
p2 = [A(i,3) A(i,4) 1]';
i = 240;
p3 = [A(i,1) A(i,2) 1]';
p4 = [A(i,3) A(i,4) 1]';
i = 712;
p5 = [A(i,1) A(i,2) 1]';
p6 = [A(i,3) A(i,4) 1]';
i = 565;
p7 = [A(i,1) A(i,2) 1]';
p8 = [A(i,3) A(i,4) 1]';

% ToDo: compute the lines l1, l2, l3, l4, that pass through the different pairs of points

l1 = cross(p1,p2);
l2 = cross(p3,p4);
l3 = cross(p5,p6);
l4 = cross(p7,p8);

% show the chosen lines in the image
figure;imshow(I);
hold on;
t=1:0.1:1000;
plot(t, -(l1(1)*t + l1(3)) / l1(2), 'y');
plot(t, -(l2(1)*t + l2(3)) / l2(2), 'y');
plot(t, -(l3(1)*t + l3(3)) / l3(2), 'y');
plot(t, -(l4(1)*t + l4(3)) / l4(2), 'y');

% ToDo: compute the homography that affinely rectifies the image

v1 = cross(l1,l2);
v2 = cross(l3,l4);
l = cross(v1,v2);

Ha = [1 0 0; 0 1 0; l(1, 1)/l(3,1) l(2, 1)/l(3,1) l(3,1)/l(3,1)];

I2 = apply_H(I, Ha);

% ToDo: compute the transformed lines lr1, lr2, lr3, lr4
pr1 = Ha*p1;
pr2 = Ha*p2;
pr3 = Ha*p3;
pr4 = Ha*p4;
pr5 = Ha*p5;
pr6 = Ha*p6;
pr7 = Ha*p7;
pr8 = Ha*p8;

lr1 = cross(pr1,pr2);
lr2 = cross(pr3,pr4);
lr3 = cross(pr5,pr6);
lr4 = cross(pr7,pr8);


% imagino que esto se ha de hacer de la siguiente manera, no como antes
% lr1 = Ha*l1;
% lr2 = Ha*l2;
% lr3 = Ha*l3;
% lr4 = Ha*l4;

% show the transformed lines in the transformed image
figure;imshow(uint8(I2));
hold on;
t=1:0.1:1000;
plot(t, -(lr1(1)*t + lr1(3)) / lr1(2), 'y');
plot(t, -(lr2(1)*t + lr2(3)) / lr2(2), 'y');
plot(t, -(lr3(1)*t + lr3(3)) / lr3(2), 'y');
plot(t, -(lr4(1)*t + lr4(3)) / lr4(2), 'y');

% ToDo: to evaluate the results, compute the angle between the different pair 
% of lines before and after the image transformation
omega = [[1 0 0];[0 1 0];[0 0 0]];

%cos(alhpa) != 0
alpha = acos(dot(omega*l1,l3)/(sqrt(dot(omega*l1,l1))*sqrt(dot(omega*l3,l3)))); 

%cos(alphar) == 0
alphar = acos(dot(omega*lr1,lr3)/(sqrt(dot(omega*lr1,lr1))*sqrt(dot(omega*lr3,lr3)))); 

a=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Metric Rectification

%% 3.1 Metric rectification after the affine rectification (stratified solution)

% ToDo: Metric rectification (after the affine rectification) using two non-parallel orthogonal line pairs
%       As evaluation method you can display the images (before and after
%       the metric rectification) with the chosen lines printed on it.
%       Compute also the angles between the pair of lines before and after
%       rectification.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. OPTIONAL: Metric Rectification in a single step
% Use 5 pairs of orthogonal lines (pages 55-57, Hartley-Zisserman book)

%% 5. OPTIONAL: Affine Rectification of the left facade of image 0000

%% 6. OPTIONAL: Metric Rectification of the left facade of image 0000

%% 7. OPTIONAL: Affine Rectification of the left facade of image 0001

%% 8. OPTIONAL: Metric Rectification of the left facade of image 0001


