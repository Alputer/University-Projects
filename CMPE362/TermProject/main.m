


image1 = imread('image1.jpg');
image2 = imread('image2.jpg');
image3 = imread('image3.jpg');
image4 = imread('image4.jpg');
image5 = imread('image5.jpg');

edgeImage1 = cannyEdgeDetector(image1, 1, 0.05, 50);
edgeImage2 = cannyEdgeDetector(image2, 1, 0.05, 90);
edgeImage3 = cannyEdgeDetector(image3, 1, 0.05, 30);
edgeImage4 = cannyEdgeDetector(image4, 1, 0.05, 70);
edgeImage5 = cannyEdgeDetector(image5, 1, 0.05, 50);

figure;
imshow(edgeImage1);

figure;
imshow(edgeImage2);

figure;
imshow(edgeImage3);

figure;
imshow(edgeImage4);

figure;
imshow(edgeImage5);