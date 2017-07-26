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
white = 255;
searchX = [-1,0,1,
           -1,0,1,
           -1,0,1];
searchY = [-1,-1,-1,
            0, 0, 0,
            1, 1, 1];
lutSize = x*y;
label = zeros(y+2,x+2);                 %追跡済み座標格納用
lookupTable = [];         %同一連結成分の設定
%lookupTable = updataLUT(lookupTable,7,12)
lutpoint = 1;
nextlabel = 1;
%-----目標画素値の探索-----
c = 'check';
for m=2:y+1
    for n=2:x+1
        %-----探索画素が見つかるまでループ-----
        if img(m,n) ~= searchValue
            continue;
        end
        %-----ラベルの更新-----
        for k = [1,2]%左上と上
            if label(m+searchY(k),n+searchX(k)) ~= 0
                label(m,n) = label(m+searchY(k),n+searchX(k));
                if label(m,n) == 0 & 
                    label(m+searchY(k),n+searchX(k))
                end
                break;
            end
        end
        if label(m,n) ~= 0
        %if true;
            for k = [2,3,4]%上と右上と左
                if label(m+searchY(k),n+searchX(k)) ~= 0 & label(m+searchY(k),n+searchX(k)) ~= label(m,n)
                %lookpuTable更新----------------------------------
                lookupTable = updataLUT(lookupTable,label(m,n),label(m+searchY(k),n+searchX(k)));
                end
            end
            
            pretrue = 1;
            for k = [1,2]%左上と上
                if img(m+searchY(k),n+searchX(k)) ~= white
                    pretrue = 0;
                    break;
                end
            end
            if pretrue == 1 & label(m+searchY(4),n+searchX(4)) ~= 0
            %lookpuTable更新----------------------------------
            lookupTable = updataLUT(lookupTable,label(m,n),label(m+searchY(4),n+searchX(4)));
            end
        end
        if label(m+searchY(3),n+searchX(3)) ~= 0 & img(m+searchY(6),n+searchX(6)) == white & label(m+searchY(k),n+searchX(k)) ~= label(m,n)
            %lookpuTable更新----------------------------------
            label(m,n)= label(m+searchY(3),n+searchX(3));
        end
        pretrue = 1;
        for k = [1,2]%左上と上と左
            if img(m+searchY(k),n+searchX(k)) ~= white
                pretrue = 0;
                break;
            end
        end
        if pretrue == 1
            if img(m+searchY(4),n+searchX(4)) ~= white
                img(m+searchY(4),n+searchX(4))
            end
            label(m,n) = nextlabel;
            nextlabel = 1+nextlabel;
        end
    end
end

renVal = zeros(nextlabel-1,nextlabel-1);
for k = 1 : nextlabel-1
    rvc = 1;
    search = find(lookupTable == k);

    for l = search'; %'
        if l <= length(lookupTable)
            l = l + length(lookupTable);
        else
            l = l - length(lookupTable);
        end
        save = 1;
        for m = 1:rvc-1
            if renVal(m) == 0
                break;
            end
            if renVal(k,m) == lookupTable(l)
                save = 0;
                break;
            end
        end
        if save == 1
            renVal(k,rvc) = lookupTable(l);
            rvc = rvc + 1;
        end
    end
end

lookupTable2 = zeros(nextlabel-1,nextlabel-1);
valSet = [1:nextlabel-1];
exit = 1;
while true
    for k = 1 : nextlabel-1
            min = valSet(k);
        for m = 1 : nextlabel-1
            if renVal(k,m) == 0
                break;
            end
            if renVal(k,m) < min
                min = renVal(k,m);
                exit = 0;
            end
            if valSet(renVal(k,m)) < min
                min = valSet(renVal(k,m));
                exit = 0;
            end
        end
        if min ~= valSet(k)
            valSet(k) = min;
        end
    end
    if exit == 1
        break
    end
    exit = 1;
end

type = unique(valSet);
for m = 1:length(type)
    for n = 1:length(valSet)
        if valSet(n) == type(m)
            valSet(n) = m;
        end
    end
end

for m=2:y+1
    for n=2:x+1
        if label(m,n) ~= 0
            label(m,n) = valSet(label(m,n));
        end
    end
end

maxLabel = max(valSet);

result = zeros(y,x,3);
for m=2:y+1
    for n=2:x+1
        if label(m,n) ~= 0
            result(m,n,1) = label(m,n)/maxLabel;
            result(m,n,2) = 1;
            result(m,n,3) = 1;
        else

            result(m,n,3) = 1;
        end
    end
end

resultImg = hsv2rgb(result);
imshow(resultImg);