%% --------------------------------------------------------------------- %%
%    >> GLULAM                                                            %
%    >> 3 CAMADAS                                                         %
%    >> INPUT 1                                                           %
%-------------------------------------------------------------------------%

% Materiais
E_solid = [13400E6 670E6 911.2E6];   %E para material em PA
rho = 480;                           %material density kg/m3
v = [0.292 0.39 0.449];              %Poisson
g = [857.6E6 93.8E6 1045.2E6];

% Beso parameters
final_volume = 0.5; 
ARmax = 4/100;
radius = 18E-3;
p = 3;
x_min = 1E-4;
ER = 4/ 100;

% Convergence identifiers
is_converged = 0;
difference = 1;
loop = 0; 
N = 5;  
tau = 0.001; % Convergence tolerance

% geometry and mesh
ply = 6;

esize = 0.01;

x = 1.5;
y = 30E-3;
z = 0.12;


% ponto P 
%         [x1 x2 y1 y2 z1 z2]
p_point = [0  0  y*6  y*6  z/2  z/2];

%periodic parameters
ncx = 3; %number of cells in X usando 5
ncy = 1; %number of cells in Y
ncz = 1; %number of cells in Z
ncs = [ncx ncy ncz];
ncells = ncx*ncy*ncz;
xc = x/ncx; 
yc = y*ply/ncy; 
zc = z/ncz; 