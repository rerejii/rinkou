%-----初期化処理-----
clear;
%-----画像読み出し-----
img = imread('two_mohu.png');         %画像の読み込み
[y,x,z] = size(img);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)

searchValue = 0;
searchX = [-1,0,1,1,1,0,-1,-1];
searchY = [-1,-1,-1,0,1,1,1,0];
entryCode = [5,6,7,0,1,2,3,4];
tracked = zeros(y,x);
entryDirection = zeros(y,x);

nextEntry = 0;
boxSize = 8;
modVal = boxSize;
loopbox = boxSize-1;
exit = 0;

for m=2:y-1
    %if (exit == 1);
    %    break
    %end
    for n=2:x-1
        %if (exit == 1);
        %    break
        %end
        %---要素の捜索---
        if (img(m,n) ~= searchValue | img(m,n-1) == searchValue | tracked(m,n) ~= 0);
            continue;
        end
        %---輪郭追跡の初期化---
        nextEntry = 1;
        entryDirection(m,n) = nextEntry;
        tracked(m,n) = 1;
        sx = n;
        sy = m;
        exit = 0;
        %---輪郭追跡---
        while (exit==0)
            for k=0:loopbox
                boxX = sx+searchX(mod(k+nextEntry,modVal)+1);
                boxY = sy+searchY(mod(k+nextEntry,modVal)+1);
                if img(boxY,boxX) == searchValue;
                    if tracked(boxY,boxX) == 0;
                        tracked(boxY,boxX) = 1;
                        entryDirection(boxY,boxX) = entryCode(mod(k+nextEntry,modVal)+1);
                        nextEntry = entryCode(mod(k+nextEntry,modVal)+1);                
                    elseif entryDirection(boxY,boxX) == entryCode(mod(k+nextEntry,modVal)+1)
                        exit=1
                    else
                        nextEntry = entryCode(mod(k+nextEntry,modVal)+1);
                    end
                    sx = boxX;
                    sy = boxY;
                    break;
                end
            end
        end
    end
end
figure(5);
im=tracked*255;
imshow(im);
