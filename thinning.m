%[P9][P2][P3]
%[P8][P1][P4]
%[P7][P6][P5]
%

%-----初期化処理-----
clear;
%-----画像読み出し-----
im = imread('two_mohu.png');             %画像の読み込み
[y,x,z] = size(im);                     %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----画像周辺に画素追加-----
img = uint8(ones(y+2,x+2).*255);        %画像より一回り大きい白(255)配列作成
img(2:y+1,2:x+1) = im;                  %読み込んだ画像に適用
searchValue = 0;
white = 255;
black = 0;
searchX = [0,0,1,1,1,0,-1,-1,-1];
searchY = [0,-1,-1,0,1,1,1,-1,-1];
searchData = img;
changeData = img;
changed = 0;
while true
    %-----ステップ1-----
    for m=2:y+1
        for n=2:x+1
            %-----探索画素が見つかるまでループ-----
            if searchData(m,n) ~= black
                continue;
            end
            if f1(searchData,m,n) ~= 1
                continue;
            end
            if f2(searchData,m,n) < 2 | f2(searchData,m,n) > 6
                continue;
            end
            if searchData(m+searchY(2),n+searchX(2))==black & searchData(m+searchY(4),n+searchX(4))==black & searchData(m+searchY(6),n+searchX(6))==black
                continue;
            end
            if searchData(m+searchY(4),n+searchX(4))==black & searchData(m+searchY(6),n+searchX(6))==black & searchData(m+searchY(8),n+searchX(8))==black
                continue;
            end
            changeData(m,n) = white;
            changed = 1;
        end
    end
    searchData = changeData;

    %-----ステップ2-----
    for m=2:y+1
        for n=2:x+1
            %-----探索画素が見つかるまでループ-----
            if searchData(m,n) ~= black
                continue;
            end
            if f1(searchData,m,n) ~= 1
                continue;
            end
            if f2(searchData,m,n) < 2 | f2(searchData,m,n) > 6
                continue;
            end
            if searchData(m+searchY(2),n+searchX(2))==black & searchData(m+searchY(4),n+searchX(4))==black & searchData(m+searchY(8),n+searchX(8))==black
                continue;
            end
            if searchData(m+searchY(2),n+searchX(2))==black & searchData(m+searchY(6),n+searchX(6))==black & searchData(m+searchY(8),n+searchX(8))==black
                continue;
            end
            changeData(m,n) = white;
            changed = 1;
        end
    end
    searchData = changeData;
    if changed == 0;
        break;
    end
    changed = 0;
end

imshow(searchData);
imwrite(searchData,'thinninged.png')
