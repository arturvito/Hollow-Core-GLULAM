function [SENE,SENEj,SENEjj,ux,uy,uz] = getSENE(odir)

for l_step=1:3
    for steps=1:1%freq_steps
        file_result_name = ['_' num2str(l_step) '_' num2str(steps) '.dat'];

        if l_step == 1
            % get SENE
            filename =  [odir '/SENE' file_result_name ];
            SENE = readmatrix(filename);

            %get displacement
            filename =  [odir '/UX' file_result_name ];
            ux = readmatrix(filename);

            %get displacement
            filename =  [odir '/UY' file_result_name ];
            uy = readmatrix(filename);
            
            %get displacement
            filename =  [odir '/UZ' file_result_name ];
            uz = readmatrix(filename);
        end

        if l_step == 2
            % get SENE
            filename =  [odir '/SENE' file_result_name ];
            SENEj = readmatrix(filename);

        end

        if l_step == 3
            % get SENE
            filename =  [odir '/SENE' file_result_name ];
            SENEjj = readmatrix(filename);

        end
    end
end
 
end


