%配列格納順番
%searchX，searchYはこの順番に基づいている
%[1,2,3
% 8,-,4
% 7,6,5]

%-----初期化処理-----
clear;
%-----画像読み出し-----
im = imread('inp.png');         %画像の読み込み
[y,x,z] = size(im);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)
im = erosion(im);
im = dilation(im);

im = dilation(im);
im = erosion(im);
figure(5);
imshow(im);

