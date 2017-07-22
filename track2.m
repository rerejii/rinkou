%配列格納順番
%searchX，searchY，entryCodeはこの順番に基づいている
%[1,2,3
% 8,-,4
% 7,6,5]
%進入方向番号
%searchX，searchY，entryCodeはこの順番に基づいている
%[0,1,2
% 7,-,3
% 6,5,4]

%-----初期化処理-----
clear;
%-----画像読み出し-----
im = imread('two_usa.png');         %画像の読み込み
[y,x,z] = size(im);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)
%-----画像周辺に画素追加-----
img = uint8(ones(y+2,x+2).*255);    %画像より一回り大きい白(255)配列作成
img(2:y+1,2:x+1) = im;              %読み込んだ画像に適用
%-----初期値設定-----
searchValue = 0;                    %探索で探すべき値の設定
searchX = [-1,0,1,1,1,0,-1,-1];     %3*3探索の際の横座標調整用
searchY = [-1,-1,-1,0,1,1,1,0];     %3*3探索の際の縦座標調整用
entryCode = [5,6,7,0,1,2,3,4];      %進入方向から座標算出用
tracked = zeros(y+2,x+2);           %追跡済み座標格納用
entryDirection = zeros(y+2,x+2);    %進入方向保存用(更新は1本の輪郭追跡ごとの初回)
check = zeros(y+2,x+2);             %追跡済み座標格納用(1本の輪郭追跡ごとにリセット)
boxSize = 8;                        %探索を行う範囲のサイズ
modVal = boxSize;                   %余りを求める際に使用
loopbox = boxSize-1;                %画素周辺の探索の繰り返し回数
exit = 0;                           %処理の終了用スイッチ
%-----目標画素値の探索-----
for m=2:y-1
    for n=2:x-1
    %-----目標画素値であり，左画素が反する画素であり，未追跡画素を見つけるまでループ-----
    if (img(m,n) ~= searchValue | img(m,n-1) == searchValue | tracked(m,n) ~= 0);
        continue;
    end
    %-----輪郭追跡で称する変数の初期化-----
    nextEntry = 1;                  %現在の画素にどの方向から進入したか
    entryDirection(m,n) = nextEntry;%右から進入したことを格納
    tracked(m,n) = 1;               %探索済みと更新
    sx = n;                         %x座標のコピー
    sy = m;                         %y座標のコピー
    exit = 0;                       %処理の終了用スイッチ
    check = zeros(y+2,x+2);         %追跡済み座標格納用(1本の輪郭追跡ごとにリセット)
    %-----輪郭追跡-----
    while (exit==0)                 %終了条件を満たすまで続ける
        for k=0:loopbox             %画素周辺の探索
            %-----探索座標の算出-----
            boxX = sx+searchX(mod(k+nextEntry,modVal)+1);
            boxY = sy+searchY(mod(k+nextEntry,modVal)+1);
            %-----連続画素の探索-----
            if img(boxY,boxX) == searchValue;
                %-----現在の輪郭追跡で探索済みか判定-----
                if check(boxY,boxX) == 0;
                    %-----未探索なら進入方向、探索判定、次の進入方向の更新-----
                    tracked(boxY,boxX) = 1;
                    check(boxY,boxX) = 1;
                    entryDirection(boxY,boxX) = entryCode(mod(k+nextEntry,modVal)+1);
                    nextEntry = entryCode(mod(k+nextEntry,modVal)+1);
                elseif entryDirection(boxY,boxX) == entryCode(mod(k+nextEntry,modVal)+1)
                    %-----一周できたことを確認したら終了-----
                    exit=1;
                else
                    %-----次の進入方向のみ更新-----
                    nextEntry = entryCode(mod(k+nextEntry,modVal)+1);
                end
                %-----座標を更新して次の探索へ-----
                sx = boxX;
                sy = boxY;
                break;
            end
            %-----1ドットが検出された際はここで終了する-----
            if(k ==loopbox)
                exit=1;
            end
        end
    end
end
end
%-----画像の出力-----
figure(5);
result=tracked*255;
resultImg=result(2:y-1,2:x-1);
imshow(resultImg);
