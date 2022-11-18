%% --------------------------------------------------------------------- %%
%                          ** Main Program **                             %
%-------------------------------------------------------------------------%
clear,clc,close all

% Create odir
odir = workingdirectory();

% Load Input and save a copy
input_file = "inputs_ex1.m";
run(input_file);
copyfile(input_file,odir);

%build file to read db
build_ansys_ex1(E_solid,rho,g,v,x,y,z,p,x_min,ply,esize)

%run first script
tic
run_ANSYS(odir,'first');
t1 = toc;

disp(['         Model creation + first run: ' sprintf('%3.3f',t1)])

% Getting information 
[nelem,nnodes,ELIST,NLIST,element_vol,centroids] = getvalues(odir);
[SENE,SENEj,SENEjj,ux,uy,uz] = getSENE(odir);

% P node
P_node = find(NLIST(:,2)>=p_point(1) & NLIST(:,2)<=p_point(2)...
            & NLIST(:,3)>=p_point(3) & NLIST(:,3)<=p_point(4)...
            & NLIST(:,4)>=p_point(5) & NLIST(:,4)<=p_point(6)   );

% loop 0
% Prepare BESO
beso = BESO(final_volume,nelem,nnodes,element_vol,ARmax,ER,x_min);

% build H matrix
tic
H = BuildFilterMatrix_3D(beso,radius,centroids(1:beso.nelem,:));
th = toc/60;

%periodic cells
cells = zeros(beso.nelem,ncs(1));
cells = periodic_cells(centroids,xc,yc,zc,ncs,esize,nelem);

cell_densities_reference = beso.densities(cells(:,end));

for c=1:ncells
    beso.densities(cells(:,c)) = cell_densities_reference;    
end

% Objective 
beso.objective = sum(uy(P_node));

% Sensitivities
beso.objective_sensitivities = (p.*(SENEjj(1:beso.nelem)-SENE(1:beso.nelem)-SENEj(1:beso.nelem)));

% Filtering sensitivities
beso.objective_sensitivities = H*beso.objective_sensitivities;

% Storing sensitivities for the next iteration averaging
sensitivities_previous = beso.objective_sensitivities;

%periodic sensitivity
beso.objective_sensitivities = periodic_sens(beso,cells,beso.objective_sensitivities);

% Initial volume
beso.initial_volume = sum(beso.element_vol(1:length(beso.densities))); 

%Current volume fraction
beso.volume_fraction = sum(beso.element_vol(find(beso.densities == 1)))/beso.initial_volume;

% Ploting sensitivities
fig_sens = figure;
plot_sensitivities_full(ELIST,NLIST,beso,beso.objective_sensitivities,x,y,z);
exportgraphics(fig_sens,[odir '/plots/sens_' num2str(loop) '.png' ],'Resolution',400)

% Storing optimization history
beso.history(loop+1,1) = beso.objective;
beso.history(loop+1,2) = beso.volume_fraction;
t_i = zeros(300,1);

% Print optimization status on the screen
disp([' It.: ' sprintf('%3i',loop) '  Obj.: ' sprintf('%5.6e',full(beso.objective))...
    '  Vol.: ' sprintf('%3.3f',beso.volume_fraction)]);
plot_aux = 0;

while (is_converged == 0)
    tic
    
    % Iteration counter update
    loop = loop + 1;  
    % Solve with BESO design update scheme
    beso = BESODesignUpdate(beso);
    
    % Initialize densities
    void_elements = find(beso.densities == 0);    
    solid_elements = find(beso.densities == 1); 
    
    % Build APDL update topology
    build_update(void_elements)
    
    % Run update topology script APDL
    run_ANSYS(odir,'update');    
 
    % Getting information 
    [SENE,SENEj,SENEjj,ux,uy,uz] = getSENE(odir);

    % Objective 
    beso.objective = sum(uy(P_node));

    % Sensitivities
    beso.objective_sensitivities = (p.*(SENEjj(1:beso.nelem)-SENE(1:beso.nelem)-SENEj(1:beso.nelem)));

    %filtering sensitivities
    beso.objective_sensitivities = H*beso.objective_sensitivities;    

    %Evaluating average of alpha history
    beso.objective_sensitivities = (beso.objective_sensitivities+sensitivities_previous)/2;
    sensitivities_previous = beso.objective_sensitivities;
    
    %periodic sensitivity
    beso.objective_sensitivities = periodic_sens(beso,cells,beso.objective_sensitivities);
    
    %Current volume fraction
    beso.volume_fraction = sum(beso.element_vol(find(beso.densities == 1)))/beso.initial_volume;

    % Storing optimization history
    beso.history(loop+1,1) = beso.objective;
    beso.history(loop+1,2) = beso.volume_fraction;

    if (loop >= 2*N) % Analyzing 2*N consecutive iterations
        error_2 = zeros(N,1);
        error_2 = zeros(N,1);
        for i = 1:N
            error_1(i) = abs(beso.history(loop-i+1,1)-beso.history(loop-N-i+1,1));
            error_2(i) = abs(beso.history(loop-i+1,1));
        end
        % Evaluating convergence
        difference = abs(sum(error_1))/sum(error_2);
        % Verifying error tolerance and if constraint is satisfied
        if ((difference <= tau) && (beso.volume_fraction <= 1.001*beso.final_volume_fraction))
            is_converged = 1;
        end
    end
     
    % Stop at maximum iterations
    if (loop == 200)
        break
    end

    t_i(loop)=toc;

    % Print results
    disp([' It.: ' sprintf('%3i',loop) '  Obj.: ' sprintf('%5.6e',full(beso.objective))...
        '  Vol.: ' sprintf('%3.3f',beso.volume_fraction)...
        '  Conv.: ' sprintf('%4.4f',difference)...
        ' It. time: ' sprintf('%3.3f',t_i(loop))])
    
    if plot_aux == 0 
        close all
        % Ploting sensitivities
        fig_sens = figure;
        plot_sensitivities_full(ELIST,NLIST,beso,beso.objective_sensitivities,x,y,z);
        exportgraphics(fig_sens,[odir '/plots/sens_' num2str(loop) '.png' ],'Resolution',400)
    else
        plot_aux = plot_aux+1;
    end
    
end

t_i(t_i==0)=[];
t = sum(t_i)/60;
disp(['Time to create H-matrix: ' sprintf('%5.3f',th) 'min'])
disp(['Time to run all iterations: ' sprintf('%5.3f',t) 'min'])
        
% % Ploting compliance history
fig_his = figure;
plot_compliance(loop,beso.history(:,1),[0.4 1],beso)
exportgraphics(fig_his,[odir '/plots/history_design_domain.eps'],'Resolution',300)
exportgraphics(fig_his,[odir '/plots/history_design_domain.png'],'Resolution',300)


save([odir '/workspace.mat'])
