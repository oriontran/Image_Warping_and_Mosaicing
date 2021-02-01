function [cord1, cord2] = get_points(im1, im2)
imagesc(im1);
[x1, y1] = ginput(10);
imagesc(im2)
[x2, y2] = ginput(10);
x1 = x1';
x2 = x2';
y1 = y1';
y2 = y2';
cord1 = [x1; y1];
cord2 = [x2; y2];
