%-----初期化処理-----
clear;
%-----画像読み出し-----
im = imread('two_usa.png');             %画像の読み込み
[y,x,z] = size(im);                     %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----画像周辺に画素追加-----
img = uint8(ones(y+2,x+2).*255);        %画像より一回り大きい白(255)配列作成
img(2:y+1,2:x+1) = im;                   %読み込んだ画像に適用
%-----初期値設定-----
searchValue = 0;                       %探索で探すべき値の設定
searchX = [-1,0,-1];                    %3*3探索の際の横座標調整用
searchY = [-1,-1,0];                    %3*3探索の際の縦座標調整用
entryCode = [5,6,7,0,1,2,3,4];          %進入方向から座標算出用
label = zeros(y+2,x+2);                 %追跡済み座標格納用
lutSize = x*y
lookupTable = zeros(2,lutSize);         %同一連結成分の設定
lutpoint = 1;
nextlabel = 1;
%-----目標画素値の探索-----
for m=2:y-1
    for n=2:x-1
        %-----探索画素が見つかるまでループ-----
        if (img(m,n) ~= searchValue)
            continue;
        end
        %-----ラベルの更新-----
        if label(m-1,n) ~= 0        %
            label(m,n) = label(m-1,n);
            if label(m,n-1) ~= 0
                lookupTable = updateLabel(lookupTable,label(m-1,n),label(m,n-1));
            end
        elseif label(m-1,n+1) ~= 0
            label(m,n) = label(m-1,n-1);
            if label(m,n-1) ~= 0
                lookupTable = updateLabel(lookupTable,label(m-1,n-1),label(m,n+1));
            end
        elseif label(m,n-1) ~= 0
            label(m,n) =  nextlabel;
            nextlabel = nextlabel + 1;
        end
    end
end

sortingTable = zeros(nextlabel-1,nextlabel-1);  %同一連結成分の設定
for k = nextlabel-1
    for l = nextlabel-1
        point = 1;
        for m = 1:lutSize
        if lookupTable(1,m) == 0
            break;
        end
        if lookupTable(1,m) == k & lookupTable(2,m) == l
            sortingTable(k,point) = l
            break;
        end
    end
end

for m=2:y-1
    for n=2:x-1
    %-----探索画素が見つかるまでループ-----
    if (img(m,n) ~= searchValue)
        continue;
    end
    for l = 1:x
        if label(m,n) == lookupTable(1,l);

    end
    end
end
