function cells = periodic_cells(centroids,xc,yc,zc,ncs,esize,nelem)

    cent = centroids((1:nelem),:);
    cent(:,1) = cent(:,1);
    cells = zeros(length(cent)/(ncs(1)*ncs(2)*ncs(3)),(ncs(1)*ncs(2)*ncs(3)));
    aux = 1;
    for j = 1:ncs(3)
        for k = 1:ncs(2)
            for m = 1:ncs(1)
               idx = find(cent(:,1)>=xc*(m-1)+esize/10 & cent(:,1)<=xc*(m)+esize/10 &...
                          cent(:,2)>=yc*(k-1)+esize/10 & cent(:,2)<=yc*(k)+esize/10 &...
                          cent(:,3)>=zc*(j-1)+esize/10 & cent(:,3)<=zc*(j)+esize/10 );                      
               cells(:,aux) = idx;
               aux = aux+1;
            end                
        end
    end  
end