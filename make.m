%p-タイル法
%読み込む画像の切り取る領域を58%と仮定

%-----初期化処理-----
clear;
%-----画像読み出し-----
img = imread('mohu2.png');         %画像の読み込み
figure(1);
imshow(img);
[y,x,z] = size(img);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----RGB値の取り出し-----
r = double(img(:,:,1));              %R値取得
g = double(img(:,:,2));              %G値取得
b = double(img(:,:,3));              %B値取得
%-----グレースケール化-----
gray = 0.3*r+0.59*g+0.11*b;          %グレイスケール化
figure(3);
imshow(uint8(gray));
imwrite(uint8(gray),'gray_usa.png');
%-----降順ソート-----
sdata = sort(gray(:),'descend');     %降順にソート
%-----閾値設定-----
p = 0.60                             %p値を58%と指定する
t = sdata(round((x*y)*p));           %39150番目の画素値を閾値にする
t = 127;
%-----2値化処理-----
two_color = zeros(y,x);              %ゼロ配列を作成
two_color(gray>=t) = 255;            %閾値以下の画素値に255(白)を格納
%-----画像表示-----
figure(4);
imshow(two_color);
imwrite(two_color,'two.png');
