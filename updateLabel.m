function lookupTable = updateLabel(lookupTable,par,cil)
[ty, tx] = size(lookupTable);
for k=1:tx
    if lookupTable(1,k) == par
        if lookupTable(2,k) == cil
            break;
        end
    end
    if lookupTable(1,k) == 0
        lookupTable(1,k) = par;
        lookupTable(2,k) = cil;
        break;
    end
  end
end
