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
                if label(m,n) == 0
                    label(m+searchY(k),n+searchX(k))
                end
                break;
            end
        end
        if label(m,n) ~= 0
            foK = [2,3,4];
            for k = [2,3,4]%上と右上と左
                if label(m+searchY(k),n+searchX(k)) ~= 0 & label(m+searchY(k),n+searchX(k)) ~= label(m,n)
                %lookpuTable更新----------------------------------
                lookupTable = updataLUT(lookupTable,label(m,n),label(m+searchY(k),n+searchX(k)));
                    if label(m,n) < label(m+searchY(k),n+searchX(k))
                        lookupTable;
                    end
                end
            end
            if label(m+searchY(3),n+searchX(3)) ~= 0 & img(m+searchY(3),n+searchX(3)) == white & label(m+searchY(k),n+searchX(k)) ~= label(m,n)
                %lookpuTable更新----------------------------------
                lookupTable = updataLUT(lookupTable,label(m,n),label(m+searchY(3),n+searchX(3)));
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
        pretrue = 1;
        for k = [1,2,4]%左上と上と左
            if img(m+searchY(k),n+searchX(k)) ~= white
                pretrue = 0;
                break;
            end
        end
        if pretrue == 1
            label(m,n) = nextlabel;
            nextlabel = 1+nextlabel;
        end
    end
end

renPoint = zeros(nextlabel-1,nextlabel-1);
renVal = zeros(nextlabel-1,nextlabel-1);
for k = 1 : nextlabel-1
    rpc = 1;
    rvc = 1;
    search = find(lookupTable == k);
    for l = search;
        if lookupTable(l) > k
            if l <= length(lookupTable)/2
                renPoint(k,rpc) = l+length(lookupTable)/2;
            elseif l > length(lookupTable)/2
                renPoint(k,rpc) = l-length(lookupTable)/2;
            end
            save = 1;
            for m = 1:rvc-1
                if renVal(k,m) == lookUpTable(renPoint(k,rpc))
                    save = 0;
                    break;
                end
            end
            if save == 1
                renVal(k,rvc) = lookUpTable(renPoint(k,rpc));
                rvc = rvc + 1;
            end
            rpc = rpc + 1;
        end
    end
end

minVal = zeros(1,nextlabel-1);
for k = 1 : nextlabel-1
    if (minVal(k) == 0)
        result = []
        result = expansion(renVal,k,result);
        for l = result
            if minVal(l) == 0
                minVal(l) = k;
            end
        end
    end
end
