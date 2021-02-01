imbill = imread('billboard.jpg');
imgirl = imread('girl.jpg');

[points1,points2] = get_points(imbill,imgirl);
H2 = computeH(points1,points2,imbill,imgirl);
[warpgirl,mosaicgirl] = warpImage(imbill,imgirl, H2);

imwrite(warpgirl, 'warpgirl.png');
imwrite(mosaicgirl, 'mosgirl.png');

subplot(2,1,1)
imshow(warpgirl);

subplot(2,1,2)
imshow(mosaicgirl);