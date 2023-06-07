%Clear command window and workspace
clc;
clear;

%Enter your number

myStudentNumber = 2019400288;
last3Digit = rem(rem(myStudentNumber, 1000), 220);

% Set random seed to 1
rng(1);

% Read the image

originalImage = imread("cat.png", "png");
%originalImage = imread("dog.png", "png");
%originalImage = imread("otter.png", "png");

originalImage = rgb2gray(originalImage);

% These variables include the rmse values to be plotted in the end
rmse1_values = [];
rmse2_values = [];
rmse3_values = [];

% Images to be plotted in the figure
recoveredImages = [];

height = size(originalImage, 1);
width = size(originalImage, 2);

% Downsample the image to half of its size
downSampledImage = originalImage(1:2:height,1:2:width);

% Create a version of the image with 4 copies
downSampledImageFourCopies = [downSampledImage downSampledImage ; downSampledImage downSampledImage];

% Number of bits to hide in the original Image
for n = 2:5

% Hide the most significant n bits of the downsampled image inside the least
% significant n bits of the original image.
transmittedImage = bitor(bitand(originalImage, 256 - 2^n), bitshift(downSampledImageFourCopies, -8 + n));

%Corrupt 30 rows starting from the the variable last3Digit
corruptedTransmittedImage = transmittedImage;
for i = last3Digit: 1: last3Digit+29 % For each row  
    for j = 1:512 % For each column
            corruptedTransmittedImage(i,j) = floor(rand()*256);
    end
end

% An uncorrupted quadrant
uncorruptedQuadrant = corruptedTransmittedImage(257:512,1:256);
recoveredQuadrant = rem(uncorruptedQuadrant, 2^n);
recoveredQuadrant = bitshift(rem(uncorruptedQuadrant, 2^n), 8 - n);


% Apply the upsampling algorithm from PS3
recoveredImage = zeros(width, height, "uint8");
recoveredImage(1:2:height, 1:2:width) = recoveredQuadrant;
recoveredImage(2:2:height, 2:2:width) = recoveredQuadrant;
recoveredImage(1:2:height, 2:2:width) = recoveredQuadrant;
recoveredImage(2:2:height, 1:2:width) = recoveredQuadrant;


%recoveredImage = [uncorruptedQuadrant uncorruptedQuadrant ];

%Calculate the necessary rmse values
originalImageDouble = im2double(originalImage);
transmittedImageDouble = im2double(transmittedImage);
corruptedTransmittedImageDouble = im2double(corruptedTransmittedImage);
recoveredImageDouble = im2double(recoveredImage);

rmse1_values = [rmse1_values rmse(originalImageDouble, transmittedImageDouble, "all")];
rmse2_values = [rmse2_values rmse(originalImageDouble, corruptedTransmittedImageDouble, "all")];
rmse3_values = [rmse3_values rmse(originalImageDouble, recoveredImageDouble, "all")];

%figure();
%title("n =", n);


recoveredImages = [recoveredImages; recoveredImage];

end

% Show the images

figure;
subplot(1,4,1),imshow(recoveredImages(1:512,1:512));
subplot(1,4,2),imshow(recoveredImages(513:1024, 1:512));
subplot(1,4,3),imshow(recoveredImages(1025:1536, 1:512));
subplot(1,4,4),imshow(recoveredImages(1537:2048, 1:512));

figure;

title("Plot of cat.png");
%title("Plot of dog.png");
%title("Plot of otter.png");


hold on

plot([2 3 4 5], rmse1_values);
plot([2 3 4 5], rmse2_values);
plot([2 3 4 5], rmse3_values);

legend("rmse values between original and transmitted", "rmse values between original and corrupted_transmitted", "rmse values between original and recovered");
hold off


