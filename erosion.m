%function resultImg = erosion(name)
function resultImg = erosion(im)
%-----画像読み出し-----
%im = imread(name);         %画像の読み込み
[y,x,z] = size(im);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----画像周辺に画素追加-----
img = uint8(ones(y+2,x+2).*255);    %画像より一回り大きい白(255)配列作成
img(2:y+1,2:x+1) = im;              %読み込んだ画像に適用
%result = uint8(ones(y+2,x+2).*255); %結果を格納する配列を作成する
result = uint8(zeros(y+2,x+2));
boxSize = 8;                        %探索を行う範囲のサイズ
%-----初期値設定-----
searchValue = 0;                    %探索で探すべき値の設定
checkValue = 255;                   %周囲で確認する値の設定
searchX = [-1,0,1,1,1,0,-1,-1];     %3*3探索の際の横座標調整用
searchY = [-1,-1,-1,0,1,1,1,0];     %3*3探索の際の縦座標調整用
%-----目標画素値の探索-----
for m=2:y-1
    for n=2:x-1
        %-----探索画素が見つかるまでループ-----
        if (img(m,n) ~= searchValue)
            continue;
        end
        %-----周辺画素探索用変数の初期化-----
        sx = n;                         %x座標のコピー
        sy = m;                         %y座標のコピー
        for k=1:boxSize                 %画素周辺の探索
            boxX = n+searchX(k);
            boxY = m+searchY(k);
            if img(boxY,boxX) == checkValue; %探索する値が見つかれば
                result(m,n) = checkValue; %更新する値を代入
                break;
            end
        end
    end
end
%-----画像の出力-----
%figure(5);
result=uint8(result+img);
resultImg=result(2:y-1,2:x-1);
%imshow(resultImg);
