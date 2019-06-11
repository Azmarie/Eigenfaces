clc;
clear;
close all;

% Generate random points in 3D

num = 5000;
x = rand(1,num);
y = x+rand(1,num);
z = rand(1,num)-2*x;

% Graph the data

X = ([x-mean(x); y-mean(y); z-mean(z)])
figure()
pcshow([transpose(X(1, :)),transpose(X(2, :)),transpose(X(3, :))]);
grid on;

% Calculate the covariance matrix

C = (1/num)*X*transpose(X);

% Calculate the eigenvectors and the eigenvalues of the covariance matrix

[V,D] = eig(C);

% Graph the data points within its bondary

O = transpose([x;y;z])*V;
figure()
pcshow([(O(:, 1)),(O(:, 2)),(O(:, 3))]);

% Take the first two largest eigenvectors

[val, idx] = maxk(diag(D),2);

e1=V(:,idx(1)); 
e2=V(:,idx(2));


% Reduce dimension to 2D

F = transpose([x;y;z])*[e1,e2];
figure();
scatter(F(:, 1),F(:,2),2);
axis equal

% Calculate the variance explained by this 2D graph

sum(val)/sum(diag(D))

