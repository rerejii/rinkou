%モード法
%ウサギと背景が

%-----初期化処理-----
clear;
%-----画像読み出し-----
img = imread('usagi01.png');         %画像の読み込み
[y,x,z] = size(img);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----RGB値の取り出し-----
r = double(img(:,:,1));              %R値取得
g = double(img(:,:,2));              %G値取得
b = double(img(:,:,3));              %B値取得
%-----グレースケール化-----
gray = 0.3*r+0.59*g+0.11*b;          %グレイスケール化

max_t = 0;
min_val = length(gray);
stock = zeros(1, 256);
count = 0;
for t = 0:255
    result = (-0.000006*(t.^4))+(0.003*(t.^3))+(-0.5016*(t.^2))+(24.465*t)+196;
    stock(t+1) = result;
    count = count + 1;
    if (min_val > result)
        min_val = result;
        max_t = t;
    end
end
%-----2値化処理-----
two_color = zeros(y,x);                %ゼロ配列を作成
two_color(gray>=max_t) = 255;          %閾値以下の画素値に255(白)を格納
%-----画像表示-----
figure(4);
imshow(two_color);
