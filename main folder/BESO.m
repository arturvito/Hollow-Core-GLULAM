%% --------------------------------------------------------------------- %%
%                           ** BESO class **                              %
%-------------------------------------------------------------------------%

classdef BESO
    
    %% Properties
    properties
        % BESO parameters
        ER
        ARmax
        inth
        
        % Densities {0,1}
        densities
        
        % Objective and sensitivities
        objective
        objective_sensitivities
        
        % Volume fraction
        volume_fraction
        final_volume_fraction
        
        % Optimization history
        % [ objective, constraint ,removed elements, inserted elements]
        history
        n_removed
        n_inserted

        % Elemento volumes
        element_vol
        
        % Initial Volume
        initial_volume    
        
        %number of elements and nodes in desing variable
        nelem
        nnodes
        
        x_min
    end
    
    %% Methods
    methods        
        %% Constructor
        
        function beso = BESO(final_volume_fraction_in,number_of_variables,nnodes...
                             ,element_vol,ARmax,ER,x_min)
            
            disp([' '])
            disp(['         Preparing BESO.'])
            
            % Volume constraint
            beso.final_volume_fraction = final_volume_fraction_in;
                     
            % Initial design variables
            beso.densities = ones(number_of_variables,1);
            
            % Divisões nos eixos
            beso.element_vol = element_vol;
            
            %ER
            beso.ER = ER;
            
            %ARmax
            beso.ARmax = ARmax;
            
            %x_min
            beso.x_min = x_min;
            
            %nelem
            beso.nelem = number_of_variables;
            %nnodes
            beso.nnodes = nnodes;            
            
        end % end Constructor
       

       %% Function to update structural design with BESO

    function [beso] = BESODesignUpdate(beso)

    % BESO sensitivity now being called alpha (negative sign for minimization)
    alpha = beso.objective_sensitivities;

    % Sorting objective sensitivities (alpha) in descend order
    [alpha,In] = sort(alpha,1,'descend');

    % Next iteration target volume
    % If current volume is higher than final volume
    if (beso.volume_fraction-beso.final_volume_fraction > beso.ER)
        target_volume = beso.volume_fraction*(1-beso.ER);

    % Elseif current volume is lower than final volume
    elseif (beso.volume_fraction-beso.final_volume_fraction < -beso.ER)
        target_volume = beso.volume_fraction*(1+beso.ER);

    % If current volume approached final volume
    elseif (beso.volume_fraction-beso.final_volume_fraction >= -beso.ER) && (beso.volume_fraction-beso.final_volume_fraction <= beso.ER)
        target_volume = beso.final_volume_fraction;
    end

    % Number of removal element threshold
    nath = round(target_volume*length(alpha));
    % Adjusting for even number of removed elements
    nath = round(nath/8)*8;

    % Sensitivity thresholds
    ath = alpha(nath);
    ath_add = ath;
    ath_del = ath;

    % Number of added elements
    nadd = nath-length(nonzeros(beso.densities(In(1:nath))));

    % Computing current ratio of admission
    ARi = nadd/length(alpha);

    % If admission ratio is feasible
    if (ARi <= beso.ARmax)

        % Loop for addition/removal of elements
        for i = 1:length(alpha)
            if alpha(i) < ath_del
                beso.densities(In(i)) = 0;
            elseif alpha(i) >= ath_add
                beso.densities(In(i)) = 1;
            end
        end

    % If admission ratio is not feasible
    else
        disp('ARmax Triggered')
        % Design variables sorted acordding to sensitivities
        In_mat = beso.densities(In);

        % Number of elements to be added
        nadd_ath = round(beso.ARmax*length(alpha));
        % Adjusting for even number of added elements
        nadd_ath = round(nadd_ath/8)*8;

        % Finding index i where In_mat corresponds to ath_add
        % Counting number of 0's in In_mat until it reaches nadd_nath
        aux_In_mat = 0;
        for i = 1:length(In_mat)
            if In_mat(i) == 0
                aux_In_mat = aux_In_mat+1;
                if aux_In_mat == (nadd_ath)
                    In_add = i;
                    break
                end
            end
        end

        % New ath_add
        ath_add = alpha(In_add);

        % Number of elements to be removed
        nret_ath_aux = round((target_volume-mean(beso.densities))*beso.nelem);
        % Adjusting for even number of removed elements
        nret_ath_aux = round(nret_ath_aux/8)*8;
        nret_ath = abs(nadd_ath-nret_ath_aux);

        % Finding index i where In_mat corresponds to ath_del
        % Counting number of 1's in In_mat until it reaches nret_nath
        aux_In_mat = 0;
        for i = length(In_mat):(-1):1
            if In_mat(i) == 1
                aux_In_mat = aux_In_mat+1;
                if aux_In_mat == nret_ath
                    In_ret = i;
                    break
                end
            end
        end

        % New ath_del
        ath_del = alpha(In_ret);

        % Loop for addition/removal of elements
        for i = 1:length(alpha)
            if alpha(i) <= ath_del
                beso.densities(In(i)) = 0;
            elseif alpha(i) >= ath_add
                beso.densities(In(i)) = 1;
            end
        end

    end

end % end BESODesignUpdate

    end 
        
end

        
        