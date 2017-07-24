function lookupTable = IntegrationUTL(lookupTable,cval)
ren = zeros(nextlabel-1,nextlabel-1);
for k = 1 : nextlabel-1
    renCo = 1;
    search = find(k);
    while true
        if length(search) == 0
            break;
        end
        chain = zeros(nextlabel-1,nextlabel-1);
        chainCo = 1;
        for l = search;
            if l <= length(lookupTable)/2
                ren(k,renCo) = lookupTable(l+length(lookupTable)/2);
                renCo = renCo + 1;
                chain(k,chainCo) = lookupTable(l+length(lookupTable)/2);
                chainCo = chainCo + 1;
            else l > length(lookupTable)/2
                ren(k) = lookupTable(l-length(lookupTable)/2);
                renCo = renCo + 1;
                chain(k) = lookupTable(l-length(lookupTable)/2);
                chainCo = chainCo + 1;
            end
            ren()
        end
    end
end
