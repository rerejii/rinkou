%-----初期化処理-----
clear;
%-----画像読み出し-----
im = imread('two_mohu.png');             %画像の読み込み
[y,x,z] = size(im);                     %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----画像周辺に画素追加-----
img = uint8(ones(y+2,x+2).*255);        %画像より一回り大きい白(255)配列作成
img(2:y+1,2:x+1) = im;                  %読み込んだ画像に適用
%-----初期値設定-----
searchValue = 0;                        %探索で探すべき値の設定
searchX = [0,1,-1];                     %3*3探索の際の横座標調整用
searchY = [-1,-1,0];                    %3*3探索の際の縦座標調整用
label = zeros(y+2,x+2);                 %追跡済み座標格納用
lutSize = x*y;
lookupTable = zeros(1,lutSize);         %同一連結成分の設定
lutpoint = 1;
nextlabel = 1;
%-----目標画素値の探索-----
for m=2:y+1
    for n=2:x+1
        %-----探索画素が見つかるまでループ-----
        if (img(m,n) ~= searchValue)
            continue;
        end
        %-----ラベルの更新-----
        labelbox = zeros(1,3);
        zeroCount = 3;
        for l = 1:length(labelbox)
            labelbox(l) = label(m+searchY(l),n+searchX(l));
            if label(m+searchY(l),n+searchX(l)) ~= 0
                labelbox(l) = label(m+searchY(l),n+searchX(l));
                zeroCount = zeroCount - 1;
            end
        end
        labelbox = sort(labelbox);
        if zeroCount == 3
            label(m,n) == nextlabel;
            lookupTable(nextlabel) = nextlabel;
            nextlabel = nextlabel +1;
        else
            label(m,n) == labelbox( zeroCount +1);
            for l = 1:length(labelbox)
                if lookupTable(labelbox(l)) > label(m,n);
                    lookupTable(l) =label(m,n);
                end
            end
        end
    end
end

checkVal = 1;
discovery = 0;
for m=1:nextlabel-1
      checkVal = checkVal+discovery;
      discovery = 0;
    for n= 1:nextlabel-1
        if lookupTable(n) == m
            lookupTable(n) = checkVal;
            discovery = 1;
        end
    end
end

for m=2:y-1
    for n=2:x-1
        if label(m,n) == 0
            continue;
        end
        label(m,n) = lookupTable(label(m,n))
    end
end
