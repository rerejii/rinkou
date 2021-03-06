function lookupTable = updataLUT(lookupTable,valA,valB)
[ty, tx] = size(lookupTable);

if ty == 0
    lookupTable = [lookupTable;valA, valB];
else
    for t = 1:ty
        if lookupTable(t,1) == valA
            if lookupTable(t,2) == valB
                break;
            end
        elseif lookupTable(t,2) == valA
            if lookupTable(t,1) == valB
                break;
            end
        end
        if t == ty
            lookupTable = [lookupTable;valA, valB];
        end
    end
end
