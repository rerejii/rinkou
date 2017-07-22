img = imread('otiusa.jpg');
[x,y,z] = size(img);
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);
gray = 0.3*r+0.59*g+0.11*b;
gray2 = bitshift(gray, -4)*17;
gray3 = bitshift(gray, -6)*85;
gray4 = bitshift(gray, -7)*255;

imshow(gray);
figure(2);
imshow(gray2);
figure(3);
imshow(gray3);
figure(4);
imshow(gray4);
