close all

% cd 'images_db' 
% Containing 2878 images from: http://vintage.winklerbros.net/facescrub.html

dim = 100;

imagefiles = dir('**/*.jpeg');       
nfiles = length(imagefiles);
sum_images = double(zeros(dim,dim));

for ii=1:nfiles
    currentfilename = imagefiles(ii).name;
     
    Iinitial = imread(currentfilename);
    % Get the number of rows and columns, and the number of color channels
    [rows, columns, numberOfColorChannels] = size(Iinitial);
    if numberOfColorChannels > 1
        currentimage = rgb2gray(Iinitial);
    else
        currentimage = Iinitial;
    end

    currentimage  = imresize(double(currentimage),[dim dim]);
    [m,n] = size(currentimage);
    images(:, ii) = {reshape(currentimage,[m*n,1])}; % {currentimage(:)}; 
    
end

% Calculate and show the mean face
mean_face = mean(cell2mat(images),2);
imshow(reshape(mean_face, [dim,dim]), []); % imshow(g, []) if g is double

% Get Eigens from SVD function
images_shifted = cell2mat(images)-repmat(mean_face,1,nfiles);
[evectors, score, evalues] = svd(images_shifted, 'econ');

% Display the top 10 eigenvectors
figure;
for n = 1:10
    subplot(3, ceil(10/2), n);
    evector = reshape(evectors(:,n), [dim,dim]);
    imshow(evector, []);
end

% Show origin image
img = rgb2gray(imread('ScarlettJohansson.jpeg'));
img = imresize(double(img),[dim dim]); 
figure
imshow(img, []);

% Reconstruct face with eigenface
figure;
filename = 'output.gif';

for n = 1:20
    subplot(4, ceil(20/4), n);
    
    % Retain top eigen vectors to reconstruct face
    some_evector = evectors(:,1:n*143); % size(images)/20;
    projected_img = some_evector*some_evector'*(img(:)-mean_face) + mean_face;
    recon = reshape(projected_img,[dim,dim]);
    imshow(recon, []);
    if n == 1 
        imwrite(recon,filename,'gif', 'Loopcount',inf); 
    else 
        imwrite(recon,filename,'gif','WriteMode','append'); 
    end
end
