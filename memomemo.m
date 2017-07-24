lookupTable2 = zeros(nextlabel-1,nextlabel-1);
valSet = [1:nextlabel-1];
exit = 1
while true
    for k = 1 : nextlabel-1
            min = valSet(k);
        for m = 1 : nextlabel-1
            if renVal(m) == 0
                break;
            end
            if renVal(m) < min
                min = renVal(m)
                exit = 0
            end
            if valSet(renVal(m)) < min
                min = valSet(renVal(m))
                exit = 0
            end
        end
    end
    if exit = 1
        break
    end
    exit = 1
end
