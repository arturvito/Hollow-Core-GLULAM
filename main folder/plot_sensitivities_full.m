function plot_sensitivities_full(ELIST,NLIST,beso,Variable,x,y,z)

ELIST_simp = ELIST(1:beso.nelem,7:14);
NLIST_simp = NLIST(1:beso.nnodes,2:4);

pot = 1;

plot_aux_densities = ones(length(ELIST_simp),1);
plot_aux_densities(1:length(beso.densities)) = beso.densities; 

% camadas non design domain
hold on
v1 = [0 0 0;x 0 0;x 0 y;0 0 y];
     %[x z y;x z y;x z y;x z y];
f = [1 2 3 4];
patch('Faces',f,'Vertices',v1,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v2 = [0 z 0;x z 0;x z y;0 z y];
patch('Faces',f,'Vertices',v2,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v3 = [0 0 0;0 z 0;0 z y;0 0 y];
patch('Faces',f,'Vertices',v3,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v4 = [x 0 0;x z 0;x z y;x 0 y];
patch('Faces',f,'Vertices',v4,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v5 = [0 0 0;0 z 0;x z 0;x 0 0];
patch('Faces',f,'Vertices',v5,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

%camadas non design domain
hold on
v12 = [0 0 y*5;x 0 y*5;x 0 y*6;0 0 y*6];
     %[x z y;x z y;x z y;x z y];
f = [1 2 3 4];
patch('Faces',f,'Vertices',v12,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v22 = [0 z y*5;x z y*5;x z y*6;0 z y*6];
patch('Faces',f,'Vertices',v22,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v32 = [0 0 y*5;0 z y*5;0 z y*6;0 0 y*6];
patch('Faces',f,'Vertices',v32,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v42 = [x 0 y*5;x z y*5;x z y*6;x 0 y*6];
patch('Faces',f,'Vertices',v42,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

v52 = [0 0 y*6;0 z y*6;x z y*6;x 0 y*6];
patch('Faces',f,'Vertices',v52,'FaceColor',[0.8672    0.7188    0.5273],'Linestyle','none' )

alpha(0.4)

colormap(jet)
hold on
patch('Faces',ELIST_simp(find(plot_aux_densities),[1:4]),'Vertices',NLIST_simp(:,[1,3,2]),'FaceVertexCData',sign(Variable(find(plot_aux_densities))).*(abs(Variable(find(plot_aux_densities)))).^pot,'FaceColor','flat','Linestyle','none')
patch('Faces',ELIST_simp(find(plot_aux_densities),[5:8]),'Vertices',NLIST_simp(:,[1,3,2]),'FaceVertexCData',sign(Variable(find(plot_aux_densities))).*(abs(Variable(find(plot_aux_densities)))).^pot,'FaceColor','flat','Linestyle','none')
patch('Faces',ELIST_simp(find(plot_aux_densities),[1,2,6,5]),'Vertices',NLIST_simp(:,[1,3,2]),'FaceVertexCData',sign(Variable(find(plot_aux_densities))).*(abs(Variable(find(plot_aux_densities)))).^pot,'FaceColor','flat','Linestyle','none')
patch('Faces',ELIST_simp(find(plot_aux_densities),[3,4,8,7]),'Vertices',NLIST_simp(:,[1,3,2]),'FaceVertexCData',sign(Variable(find(plot_aux_densities))).*(abs(Variable(find(plot_aux_densities)))).^pot,'FaceColor','flat','Linestyle','none')
patch('Faces',ELIST_simp(find(plot_aux_densities),[1,4,8,5]),'Vertices',NLIST_simp(:,[1,3,2]),'FaceVertexCData',sign(Variable(find(plot_aux_densities))).*(abs(Variable(find(plot_aux_densities)))).^pot,'FaceColor','flat','Linestyle','none')
patch('Faces',ELIST_simp(find(plot_aux_densities),[2,3,7,6]),'Vertices',NLIST_simp(:,[1,3,2]),'FaceVertexCData',sign(Variable(find(plot_aux_densities))).*(abs(Variable(find(plot_aux_densities)))).^pot,'FaceColor','flat','Linestyle','none')

view(35,30)
view([1 -1 1])
axis equal
axis off
end
