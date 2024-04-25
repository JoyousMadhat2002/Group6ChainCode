% Test the preprocessing function

% Load an example image
img = imread('bricks.jpg'); 

% Call the preprocessing function directly with the original image
preprocessedImage = preprocessing(img);

% Display the original and preprocessed images for comparison
figure;
subplot(1, 2, 1);
imshow(img);
title('Original Image');

subplot(1, 2, 2);
imshow(preprocessedImage);
title('Preprocessed Image');
