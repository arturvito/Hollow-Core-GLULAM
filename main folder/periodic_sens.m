function cell_sens_final = periodic_sens(beso,cells,objective_sensitivities)
    [m,n] = size(cells);
    cell_sens = zeros(size(cells));
    for i = 1:n
        cell_sens(:,i) = objective_sensitivities(cells(:,i));
    end
    
    cell_sens_unique  = sum(cell_sens,2)/(n);
    
    cell_sens_final = zeros(beso.nelem,1);
    
    for i = 1:n
        cell_sens_final(cells(:,i)) = cell_sens_unique;
    end
    
end