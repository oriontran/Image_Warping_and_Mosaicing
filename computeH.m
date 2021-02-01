function H = computeH(t1, t2, im1, im2) 
n = size(t1,2);
A = zeros(2*n,9);
for i=1:n
    temp = [t1(1,i), t1(2,i), 1.0, 0, 0, 0, -t2(1,i)*t1(1,i), -t2(1,i)*t1(2,i), -t2(1,i);
            0, 0, 0, t1(1,i), t1(2,i), 1, -t2(2,i)*t1(1,i), -t2(2,i)*t1(2,i), -t2(2,i)];
    A(2*i-1,:) = temp(1,:);
    A(2*i,:) = temp(2,:);
end
[V,D] = eig(A'*A);
[~, ind] = min(diag(D));
h_hat = V(:,ind);
H = reshape(h_hat,3,3);
H = H';
subplot(2,2,1);
imshow(im1);
hold on;
scatter(t1(1,:),t1(2,:));
title('coordinates of im1');

subplot(2,2,2);
imshow(im2);
hold on;
scatter(t2(1,:),t2(2,:));
title('coordinates of im2'); 

subplot(2,2,3);
imshow(im2);
hold on;
t1_transform = zeros(2,n);
for j=1:n
   p = [t1(:,j); 1];
   p_prime = H*p;
   t1_transform(1,j) = p_prime(1)/p_prime(3);
   t1_transform(2,j) = p_prime(2)/p_prime(3);
end
scatter(t1_transform(1,:),t1_transform(2,:));
title('calculated coordinates');
