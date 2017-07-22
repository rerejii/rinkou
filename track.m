%-----初期化処理-----
clear;
%-----画像読み出し-----
%im = imread('two_mohu.png');         %画像の読み込み
im = imread('two_usa.png');         %画像の読み込み
[y,x,z] = size(im);                 %画像のサイズ(y=縦座標,x=横座標,z=RGB)
img = uint8(ones(y+2,x+2).*255);
img(2:y+1,2:x+1) = im;

searchValue = 0;
searchX = [-1,0,1,1,1,0,-1,-1];
searchY = [-1,-1,-1,0,1,1,1,0];
entryCode = [5,6,7,0,1,2,3,4];
tracked = zeros(y+2,x+2);
entryDirection = zeros(y+2,x+2);
check = zeros(y+2,x+2);

nextEntry = 0;
boxSize = 8;
modVal = boxSize;
loopbox = boxSize-1;
exit = 0;
con = 0;
for m=2:y-1
    %if (m > 168);
    %    m
    %end
    for n=2:x-1
        %if (con == 78);
        %    n
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
        check = zeros(y+2,x+2);
        %---輪郭追跡---
        while (exit==0)
            for k=0:loopbox
                boxX = sx+searchX(mod(k+nextEntry,modVal)+1);
                boxY = sy+searchY(mod(k+nextEntry,modVal)+1);
                if img(boxY,boxX) == searchValue;
                    if check(boxY,boxX) == 0;
                        tracked(boxY,boxX) = 1;
                        check(boxY,boxX) = 1;
                        entryDirection(boxY,boxX) = entryCode(mod(k+nextEntry,modVal)+1);
                        nextEntry = entryCode(mod(k+nextEntry,modVal)+1);                
                    elseif entryDirection(boxY,boxX) == entryCode(mod(k+nextEntry,modVal)+1)
                        exit=1;
                        con = con +1
                    else
                        nextEntry = entryCode(mod(k+nextEntry,modVal)+1);
                    end
                    sx = boxX;
                    sy = boxY;
                    break;
                end
                if(k ==loopbox)
                    exit=1;
                end
            end
        end
    end
end
figure(5);
im=tracked*255;
imshow(im);
