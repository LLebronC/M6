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
% % % siguiendo la formula en lecture1 pag.31, 2 rot. Rphi y Ro, una
% translacion translation y un escalar D
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
% % % % seguir el order aplicando trnasformaciones de derecha a izquierda
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
% % % % Random H
% H=[ 0.9638   -0.0960   52.5754;
%  0.2449    1.3808  -17.0081;
% -0.0001    0.0013    1.0000];
% I2 = apply_H(I, H);
% figure; imshow(I); figure; imshow(I2);
% return
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
% figure;imshow(I);
% hold on;
% t=1:0.1:1000;
% plot(t, -(l1(1)*t + l1(3)) / l1(2), 'y');
% plot(t, -(l2(1)*t + l2(3)) / l2(2), 'y');
% plot(t, -(l3(1)*t + l3(3)) / l3(2), 'y');
% plot(t, -(l4(1)*t + l4(3)) / l4(2), 'y');

% ToDo: compute the homography that affinely rectifies the image
Ha = get_affine_rect(l1, l2, l3, l4);
I2 = apply_H(I, Ha);

% ToDo: compute the transformed lines lr1, lr2, lr3, lr4
lr1 = inv(transpose(Ha))*l1;
lr2 = inv(transpose(Ha))*l2;
lr3 = inv(transpose(Ha))*l3;
lr4 = inv(transpose(Ha))*l4;

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

alpha = acos(dot(omega*l1,l2)/(sqrt(dot(omega*l1,l1))*sqrt(dot(omega*l2,l2)))); 
alphar = acos(dot(omega*lr1,lr2)/(sqrt(dot(omega*lr1,lr2))*sqrt(dot(omega*lr2,lr2)))); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Metric Rectification

%% 3.1 Metric rectification after the affine rectification (stratified solution)

% ToDo: Metric rectification (after the affine rectification) using two non-parallel orthogonal line pairs
%       As evaluation method you can display the images (before and after
%       the metric rectification) with the chosen lines printed on it.
%       Compute also the angles between the pair of lines before and after
%       rectification.



i = 227;
p9 = [A(i,1) A(i,2) 1]';
p12 = [A(i,3) A(i,4) 1]';
i = 367;
p10 = [A(i,1) A(i,2) 1]';
p11 = [A(i,3) A(i,4) 1]';
% % % No paralel
l5= cross(p9,p10);
l6= cross(p11,p12);
lr5 = inv(transpose(Ha))*l5;
lr6 = inv(transpose(Ha))*l6;

% figure;imshow(I);
% hold on;
% t=1:0.1:1000;
% plot(t, -(l1(1)*t + l1(3)) / l1(2), 'y');
% plot(t, -(l3(1)*t + l3(3)) / l3(2), 'y');
% plot(t, -(l5(1)*t + l5(3)) / l5(2), 'y');
% plot(t, -(l6(1)*t + l6(3)) / l6(2), 'y');

Hs = get_metric_rect(lr1, lr3, lr5, lr6);
I3 = apply_H(uint8(I2), Hs);

lrr1 = inv(transpose(Hs))*lr1;
lrr3 = inv(transpose(Hs))*lr3;
lrr5 = inv(transpose(Hs))*lr5;
lrr6 = inv(transpose(Hs))*lr6;

% show the transformed lines in the transformed image
figure;imshow(uint8(I3));
hold on;
t=1:0.1:1000;
plot(t, -(lrr1(1)*t + lrr1(3)) / lrr1(2), 'y');
plot(t, -(lrr3(1)*t + lrr3(3)) / lrr3(2), 'y');
plot(t, -(lrr5(1)*t + lrr5(3)) / lrr5(2), 'y');
plot(t, -(lrr6(1)*t + lrr6(3)) / lrr6(2), 'y');

alpha_prev = acos(dot(omega*lr1,lr3)/(sqrt(dot(omega*lr1,lr1))*sqrt(dot(omega*lr3,lr3))))
alpha_orto = acos(dot(omega*lrr1,lrr3)/(sqrt(dot(omega*lrr1,lrr1))*sqrt(dot(omega*lrr3,lrr3))))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. OPTIONAL: Metric Rectification in a single step
% Use 5 pairs of orthogonal lines (pages 55-57, Hartley-Zisserman book)
i = 227;
p9 = [A(i,1) A(i,2) 1]';
p10 = [A(i,3) A(i,4) 1]';
i = 534;
p11 = [A(i,1) A(i,2) 1]';
p12 = [A(i,3) A(i,4) 1]';

i = 567;
p13 = [A(i,1) A(i,2) 1]';
p14 = [A(i,3) A(i,4) 1]';
i = 367;
p15 = [A(i,1) A(i,2) 1]';
p16 = [A(i,3) A(i,4) 1]';

i = 424;
p17 = [A(i,1) A(i,2) 1]';
p18 = [A(i,3) A(i,4) 1]';
i = 565;
p19 = [A(i,1) A(i,2) 1]';
p20 = [A(i,3) A(i,4) 1]';


%si
ol1 = l1;
om1 = l3;

%si
ol2 = l5;
om2 = l6;


i = 227;
p9 = [A(i,1) A(i,2) 1]';
p10 = [A(i,3) A(i,4) 1]';
i = 534;
p11 = [A(i,1) A(i,2) 1]';
p12 = [A(i,3) A(i,4) 1]';

ol3 = cross(p9, p10);
om3 = cross(p11, p12);



i = 424;
p13 = [A(i,1) A(i,2) 1]';
p16 = [A(i,3) A(i,4) 1]';
i = 240;
p14 = [A(i,1) A(i,2) 1]';
p15 = [A(i,3) A(i,4) 1]';
% % % No paralel
ol4= cross(p13,p14);
om4= cross(p15,p16);


i = 712;
p17 = [A(i,1) A(i,2) 1]';
p20 = [A(i,3) A(i,4) 1]';
i = 565;
p18 = [A(i,1) A(i,2) 1]';
p19 = [A(i,3) A(i,4) 1]';
% % % No paralel
ol5= cross(p17,p18);
om5= cross(p19,p20);

A = [
[ol1(1)*om1(1), (ol1(1)*om1(2)+ol1(2)*om1(1))/2, ol1(2)*om1(2), (ol1(1)*om1(3)+ol1(3)*om1(1))/2, (ol1(2)*om1(3)+ol1(3)*om1(2))/2, ol1(3)*om1(3)];
[ol2(1)*om2(1), (ol2(1)*om2(2)+ol2(2)*om2(1))/2, ol2(2)*om2(2), (ol2(1)*om2(3)+ol2(3)*om2(1))/2, (ol2(2)*om2(3)+ol2(3)*om2(2))/2, ol2(3)*om2(3)];
[ol3(1)*om3(1), (ol3(1)*om3(2)+ol3(2)*om3(1))/2, ol3(2)*om3(2), (ol3(1)*om3(3)+ol3(3)*om3(1))/2, (ol3(2)*om3(3)+ol3(3)*om3(2))/2, ol3(3)*om3(3)];
[ol4(1)*om4(1), (ol4(1)*om4(2)+ol4(2)*om4(1))/2, ol4(2)*om4(2), (ol4(1)*om4(3)+ol4(3)*om4(1))/2, (ol4(2)*om4(3)+ol4(3)*om4(2))/2, ol4(3)*om4(3)];
[ol5(1)*om5(1), (ol5(1)*om5(2)+ol5(2)*om5(1))/2, ol5(2)*om5(2), (ol5(1)*om5(3)+ol5(3)*om5(1))/2, (ol5(2)*om5(3)+ol5(3)*om5(2))/2, ol5(3)*om5(3)]
];

[U D V] = svd(A);
x = V(:,6);

a = x(1);
b = x(2);
c = x(3);
d = x(4);
e = x(5);
f = x(6);

C = [[a b/2 d/2]; [b/2 c e/2]; [d/2 e/2 f]];

[U D V] = svd(C);

H = U*D;

I4 = apply_H(uint8(I), H);
figure;imshow(uint8(I4));
%% 5. OPTIONAL: Affine Rectification of the left facade of image 0000

%% 6. OPTIONAL: Metric Rectification of the left facade of image 0000

%% 7. OPTIONAL: Affine Rectification of the left facade of image 0001

%% 8. OPTIONAL: Metric Rectification of the left facade of image 0001


