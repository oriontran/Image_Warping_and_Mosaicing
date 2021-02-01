function [warpIm, mergeIm] = warpImage(inputIm, refIm, H)
fwd_warp_corner = zeros(2,4);
[r,c,~] = size(inputIm);

warp_corner = H*[1,1,1]';
fwd_warp_corner(1,1) = warp_corner(1)/warp_corner(3);
fwd_warp_corner(2,1) = warp_corner(2)/warp_corner(3);

warp_corner = H*[1,r,1]';
fwd_warp_corner(1,2) = warp_corner(1)/warp_corner(3);
fwd_warp_corner(2,2) = warp_corner(2)/warp_corner(3);

warp_corner = H*[c,r,1]';
fwd_warp_corner(1,3) = warp_corner(1)/warp_corner(3);
fwd_warp_corner(2,3) = warp_corner(2)/warp_corner(3);

warp_corner = H*[c,1,1]';
fwd_warp_corner(1,4) = warp_corner(1)/warp_corner(3);
fwd_warp_corner(2,4) = warp_corner(2)/warp_corner(3);

[warp_x_min,~] = min(fwd_warp_corner(1,1:4));
[warp_y_min,~] = min(fwd_warp_corner(2,1:4));
[warp_x_max,~] = max(fwd_warp_corner(1,1:4));
[warp_y_max,~] = max(fwd_warp_corner(2,1:4));

box_x_min = min(1,warp_x_min);
box_y_min = min(1,warp_y_min);
box_x_max = max(size(refIm,2),warp_x_max);
box_y_max = max(size(refIm,1),warp_y_max);

total_x = round(box_x_max - box_x_min);
total_y = round(box_y_max - box_y_min);

y = 1:total_y;
x = 1:total_x;
[A,B] = meshgrid(x,y);

warpIm_ind_x = reshape(A, 1, total_x*total_y);
warpIm_ind_y = reshape(B, 1, total_x*total_y);
warpIm_ind = [warpIm_ind_x+round(box_x_min); warpIm_ind_y+round(box_y_min)];

warpIm_ind_h = [warpIm_ind; ones(1, total_x*total_y)];
og_cords_inputIm = H\warpIm_ind_h;
for i=1:total_x*total_y
    og_cords_inputIm(1,i) = og_cords_inputIm(1,i)/og_cords_inputIm(3,i);
    og_cords_inputIm(2,i) = og_cords_inputIm(2,i)/og_cords_inputIm(3,i);
end

for i=1:total_x*total_y
    if (og_cords_inputIm(1,i) >= 1  && og_cords_inputIm(2,i) >= 1 ...
        && og_cords_inputIm(2,i) < r && og_cords_inputIm(1,i) < c) 
    
        a = og_cords_inputIm(1,i) - floor(og_cords_inputIm(1,i));
        b = og_cords_inputIm(2,i) - floor(og_cords_inputIm(2,i));
        
        weight1 = ((1-a)*(1-b))*inputIm(og_cords_inputIm(2,i)-b,og_cords_inputIm(1,i)-a,:);
        
        if (og_cords_inputIm(1,i)+1-a <= c)
            weight2 = (a*(1-b))*inputIm(round(og_cords_inputIm(2,i)-b),round(og_cords_inputIm(1,i)+1-a),:);
        else
            weight2 = 0;
        end
        
        if (og_cords_inputIm(2,i)+1-b <= r && og_cords_inputIm(1,i)+1-a <=c)
            weight3 = (a*b)*inputIm(round(og_cords_inputIm(2,i)+1-b),round(og_cords_inputIm(1,i)+1-a),:);
        else
            weight3 = 0;
        end
        
        if (og_cords_inputIm(2,i)+1-b <= r)
            weight4 = ((1-a)*b)*inputIm(round(og_cords_inputIm(2,i)+1-b),round(og_cords_inputIm(1,i)-a),:);
        else
            weight4 = 0;
        end
        
        warpIm(warpIm_ind(2,i)-round(box_y_min), warpIm_ind(1,i)-round(box_x_min),:) = weight1+weight2+weight3+weight4;
        mergeIm(warpIm_ind(2,i)-round(box_y_min), warpIm_ind(1,i)-round(box_x_min),:) = weight1+weight2+weight3+weight4;
    end
end

for j=2:size(refIm,1)
    for k=2:size(refIm,2)
        mergeIm(j-round(box_y_min), k-round(box_x_min),:) = refIm(j,k,:);
    end
end
