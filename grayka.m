clear;
img = imread('usagi01.png');
[x,y,z] = size(img);
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);
gray = 0.3*r+0.59*g+0.11*b;

histData = zeros(1,256);
for k = 0:255
    data = (gray == k);
    data = sum(sum(data));
    histData(k+1) = data;
end

figure(1);
imshow(gray);
imwrite(gray,'gureusagi01.png');
[x,y] = size(gray);
figure(2);
histogram(gray);
ylabel('頻度'); %x軸ラベル
xlabel('画素値(5画素ごと)'); %y軸ラ
title('画素値ヒストグラフ');
figure(3);
histX = [0:255];
plot(histX,histData);
ylabel('頻度'); %x軸ラベル
xlabel('画素値'); %y軸ラ
title('画素値ヒストグラフ');
hid = histData';
siti = 200;
two_color = zeros(x,y);
%two_color(gray>siti) = 255:

sdata = sort(gray(:));
siti = sdata(52500);
two_color = zeros(x,y);
two_color(gray>=siti) = 255;
figure(4);
imshow(two_color);
