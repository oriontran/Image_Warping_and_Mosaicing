image1 = imread('guymos1.jpg');
image2 = imread('guymos2.jpg');

[cord1,cord2] = get_points(image1,image2);
H2 = computeH(cord1,cord2,image1,image2);
[warp1,mosaic1] = warpImage(image1,image2, H2);

imwrite(warp1,'guywarp.png');
imwrite(mosaic1,'guymos.png');

subplot(2,1,1)
imshow(warp1);

subplot(2,1,2)
imshow(mosaic1);
