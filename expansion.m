function result = expansion(renVal,openVal,result)
[sy,sx] = size(renVal);
stock = [];
for s = 1 : sy
    val = renVal(openVal,s);
    if val ~=0
        stock = [stock val];
    else
        break;
    end
end
allVal = stock;
for s = stock
    allVal = [result expansion(renVal,s)];
end
allVal = sort(allVal);
%result = [];
if allVal  ~= 0
    nowVal = allVal(1);
    result = [allVal(1)];
    for s = allVal
        if s > nowVal
            result = [result s];
        end
    end
end
result = [result openVal];
