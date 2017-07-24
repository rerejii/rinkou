exit = 1
lookupTable2 = zeros(nextlabel-1,nextlabel-1);
for K = 1:length(lookupTable)/2
    if lookupTable(k,1) < lookupTable(k,2)
        minval = lookupTable(k,1);
        nomval = lookupTable(k,2);
    else
        minval = lookupTable(k,2);
        nomval = lookupTable(k,1);
    end
    for m = 1:nextlabel-1
    if lookupTable2(nimval,m) == nomval
          break;
    end
    if lookupTable2(nimval,m) == 0
          lookupTable2(nimval,m) = nomval
    end
end
lookupTable = lookupTable2
lookupTable2 = zeros(nextlabel-1,nextlabel-1);
for K = 1:length(lookupTable)
    len = 0;
    for m = 1:nextlabel-1
        sval = lookupTable(k,m)
        if(sval == 0)
            break;
        end
        lookupTable2(k,m) = sval
        len = len + 1;
    end
    for m = 1:len
        sval = lookupTable(k,m)
        for n = len+1:nextlabel-1
            for l =
                if lookupTable2(sval,n) ==
                      break;
                end
                if lookupTable2(sval,n) == 0
                      lookupTable2(sval,n) = nomval
                end
