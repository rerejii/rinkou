img = imread('kut2.jpg');
[x,y,z] = size(img);
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);
gray = 0.3*r+0.59*g+0.11*b;

figure(1);
imshow(gray);