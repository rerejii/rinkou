function result = f1(searchData,m,n)
searchX = [0,0,1,1,1,0,-1,-1,-1];
searchY = [0,-1,-1,0,1,1,1,-1,-1];

white = 255;
black = 0;
count = 0;
beforeVal = black;
for k = [2,3,4,5,6,7,8,9,2]
    if searchData(m+searchY(k),n+searchX(k)) == black
        if beforeVal == white
            count = count + 1;
        end
        beforeVal = black;
    else
        beforeVal = white;
    end
end
result = count;
