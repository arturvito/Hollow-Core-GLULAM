function build_ansys_ex1(E_solid,rho,g,v,x,y,z,p,x_min,ply,esize)
%% --------------------------------------------------------------------- %%
%    >> GLULAM                                                            %
%    >> 5 LAYERS                                                          %
%    >> INPUT 1                                                           %
%-------------------------------------------------------------------------%



E_solid_x = E_solid(1);
E_solid_y = E_solid(2);
E_solid_z = E_solid(3);

v_XY = v(1);
v_YZ = v(2);
v_XZ = v(3);

g_XY = g(1);
g_YZ = g(2);
g_XZ = g(3);


file = fopen("ansys_in.mac", "w");   

    fprintf(file,"FINISH\r\n");
    fprintf(file,"/CLEAR,NOSTART\r\n");
    fprintf(file,"ALLSEL,ALL\r\n"); 
    
    %% PREP
    fprintf(file,"/PREP7 \r\n"); 

    fprintf(file,'MP,EX,1,%5.6f\r\n', E_solid_x);   
    fprintf(file,'MP,EY,1,%5.6f\r\n', E_solid_y);  
    fprintf(file,'MP,EZ,1,%5.6f\r\n', E_solid_z);  
    fprintf(file,'MP,PRXY,1,%5.6f\r\n', v_XY);
    fprintf(file,'MP,PRYZ,1,%5.6f\r\n', v_YZ); 
    fprintf(file,'MP,PRXZ,1,%5.6f\r\n', v_XZ);
    fprintf(file,'MP,DENS,1,%.10e \r\n', rho); 
    fprintf(file,"MP,GXY,1,%.10e\r\n", g_XY); 
    fprintf(file,"MP,GYZ,1,%.10e\r\n", g_YZ); 
    fprintf(file,"MP,GXZ,1,%.10e\r\n", g_XZ); 
    
    
    fprintf(file,'MP,EX,2,%5.6f\r\n', E_solid_x*x_min^p);   
    fprintf(file,'MP,EY,2,%5.6f\r\n', E_solid_y*x_min^p);  
    fprintf(file,'MP,EZ,2,%5.6f\r\n', E_solid_z*x_min^p);  
    fprintf(file,'MP,PRXY,2,%5.6f\r\n', v_XY);
    fprintf(file,'MP,PRYZ,2,%5.6f\r\n', v_YZ); 
    fprintf(file,'MP,PRXZ,2,%5.6f\r\n', v_XZ);
    fprintf(file,'MP,DENS,2,%.10e \r\n', rho*x_min); 
    fprintf(file,"MP,GXY,2,%.10e\r\n", g_XY*x_min^p); 
    fprintf(file,"MP,GYZ,2,%.10e\r\n", g_YZ*x_min^p); 
    fprintf(file,"MP,GXZ,2,%.10e\r\n", g_XZ*x_min^p);    
    
    %SOLID 185
    fprintf(file,'ET,1,SOLID185\r\n'); 
    fprintf(file,'KEYOPT,1,2,2\r\n');   
       
    % geometria 
    fprintf(file,'x = %f\r\n', x);  
    fprintf(file,'y = %f\r\n', y);
    fprintf(file,'z = %f\r\n', z);
    
    fprintf(file,'ply = %f\r\n', ply);
    
    for i=1:ply
    fprintf(file,'BLOCK,0,x,%f,%f,0,z \r\n',[(i-1)*y i*y]); 
    end
    fprintf(file,"ALLSEL,ALL\r\n");
    fprintf(file,"VGLUE,ALL\r\n"); 
    
    % malha design variable
    fprintf(file,"ESIZE,%f,1 \r\n",esize); 
%     fprintf(file,"LOCAL,11,0,0,0.0,0,0,0,90,1,1, \r\n");
%     
%     fprintf(file,"VSEL,S,LOC,Y,y*1,y*2 \r\n");
%     fprintf(file,"VATT,       1, ,   1,      11 \r\n");
   
    fprintf(file,"VSEL,S,LOC,Y,y*1,y*5 \r\n");
    fprintf(file,"MSHKEY,1\r\n");
    fprintf(file,"VMESH,ALL\r\n"); 
    
%     fprintf(file,"CSYS,0, \r\n"); 
    fprintf(file," ALLSEL,ALL   \r\n");    
    
    fprintf(file,'*get,nelem,ELEM,0,count\r\n');
    fprintf(file,'*get,nnode,NODE,0,count\r\n');
    fprintf(file,'*CFOPEN,malha_stat,dat\r\n');
    fprintf(file,'*VWRITE,nelem,nnode\r\n');
    fprintf(file,'%%.12e, %%.12e\r\n');
    fprintf(file,'*CFCLOS\r\n');     
 
    % malha non-design variable 
    fprintf(file,"ALLSEL,ALL\r\n");
    
    fprintf(file,"MSHKEY,1\r\n");
    fprintf(file,"VMESH,ALL\r\n");
    
    fprintf(file,"MSHKEY,1\r\n");
    fprintf(file,"VMESH,ALL\r\n");    
    
    fprintf(file,"ALLSEL,ALL\r\n");
    fprintf(file,'*get,nelem_full,ELEM,0,count\r\n');
    fprintf(file,'*get,nnode_full,NODE,0,count\r\n');
    
    % engaste
    fprintf(file,'ALLSEL,ALL                        \r\n');
    fprintf(file,'NSEL,R,LOC,X,-0.000001+0.15-0.0200,+0.000001+0.15+0.0200    \r\n');
    fprintf(file,'NSEL,R,LOC,Y,-0.000001,+0.000001  \r\n');
    fprintf(file,'NSEL,R,LOC,Z,-0.000001,+0.000001+z  \r\n');
    fprintf(file,'D,ALL, , , , , ,UY,UZ, , , ,   	\r\n');

    fprintf(file,'ALLSEL,ALL                        \r\n');
    fprintf(file,'NSEL,R,LOC,X,-0.000001-0.15+x-0.0200,+0.000001-0.15+x+0.0200     \r\n');
    fprintf(file,'NSEL,R,LOC,Y,-0.000001,+0.000001  \r\n');
    fprintf(file,'NSEL,R,LOC,Z,-0.000001,+0.000001+z  \r\n');
    fprintf(file,'D,ALL, , , , , ,UY,UZ, , , ,  	\r\n');
    
    % NLIST
    fprintf(file,"ALLSEL,ALL \r\n");  
    fprintf(file,"/PAGE, 1E9,, 1E9,,\r\n"); 
    fprintf(file,"/FORMAT, , ,14,5, ,\r\n");     
    fprintf(file,"/HEADER, off, off, off, off, on, off  \r\n");    
    fprintf(file,"/OUTPUT,NLIST,dat \r\n");      
    fprintf(file,"NLIST,ALL, , , ,NODE,NODE,NODE  \r\n");     
    fprintf(file,"/OUTPUT \r\n");  

    % ELIST
    fprintf(file,"ALLSEL,ALL \r\n");  
    fprintf(file,"/PAGE, 1E9,, 1E9,,\r\n"); 
    fprintf(file,"/FORMAT, , ,14,5, ,\r\n");     
    fprintf(file,"/HEADER, off, off, off, off, on, off  \r\n");    
    fprintf(file,"/OUTPUT,ELIST,dat \r\n");      
    fprintf(file,"ELIST,ALL, , , ,NODE,NODE,NODE  \r\n");     
    fprintf(file,"/OUTPUT \r\n");  
    
    % forca Y real
    fprintf(file,'ALLSEL,ALL 							\r\n');
    fprintf(file,"FDELE,ALL  \n") ;
    
    fprintf(file,'NSEL,R,LOC,X,-0.00001+x/2-0.0200,+0.00001+x/2+0.0200   \r\n');
    fprintf(file,'NSEL,R,LOC,Y,-0.00001+y*ply,+0.00001+y*ply  \r\n');
    fprintf(file,'NSEL,R,LOC,Z,-0.00001,+0.00001+z  \r\n');
    fprintf(file,"*get,forcenodes,node,,count  \r\n");  
    fprintf(file,'F,ALL,FY,-10000/forcenodes\r\n'); 
        
    fprintf(file,'ALLSEL,ALL 							\r\n');  
    fprintf(file,'LSWRITE,1,							\r\n');     
    fprintf(file,'FDELE,ALL 							\r\n'); 
    
    % forca Y virtual
    fprintf(file,'ALLSEL,ALL 							\r\n');
    fprintf(file,"FDELE,ALL  \n") ;
    
    fprintf(file,'NSEL,R,LOC,X,-0.00001+x/2,+0.00001+x/2   \r\n');
    fprintf(file,'NSEL,R,LOC,Y,-0.00001+y*5,+0.00001+y*5  \r\n');
    fprintf(file,'NSEL,R,LOC,Z,-0.00001+z/2,+0.00001+z/2  \r\n');    
    fprintf(file,"*get,forcenodes,node,,count  \r\n");  
    fprintf(file,'F,ALL,FY,-1/forcenodes\r\n'); 
        
    fprintf(file,'ALLSEL,ALL 							\r\n'); 
    fprintf(file,'LSWRITE,2,							\r\n');  
    fprintf(file,'FDELE,ALL 							\r\n');     

    % forca y Virtual + real    
    fprintf(file,'ALLSEL,ALL 							\r\n');
    fprintf(file,"FDELE,ALL  \n") ;
    
    fprintf(file,'NSEL,R,LOC,X,-0.00001+x/2-0.0200,+0.00001+x/2+0.0200   \r\n');
    fprintf(file,'NSEL,R,LOC,Y,-0.00001+y*ply,+0.00001+y*ply  \r\n');
    fprintf(file,'NSEL,R,LOC,Z,-0.00001,+0.00001+z  \r\n');
    fprintf(file,"*get,forcenodes,node,,count  \r\n");  
    fprintf(file,'F,ALL,FY,-10000/forcenodes\r\n'); 
    
    fprintf(file,'ALLSEL,ALL 							\r\n');
    fprintf(file,'NSEL,R,LOC,X,-0.00001+x/2,+0.00001+x/2   \r\n');
    fprintf(file,'NSEL,R,LOC,Y,-0.00001+y*5,+0.00001+y*5  \r\n');
    fprintf(file,'NSEL,R,LOC,Z,-0.00001+z/2,+0.00001+z/2  \r\n');    
    fprintf(file,"*get,forcenodes,node,,count  \r\n");  
    fprintf(file,'F,ALL,FY,-1/forcenodes\r\n'); 
    
    fprintf(file,'ALLSEL,ALL 							\r\n'); 
    fprintf(file,'LSWRITE,3,							\r\n');  
    fprintf(file,'FDELE,ALL 							\r\n');   
    
    fprintf(file,'ALLSEL,ALL 							\r\n'); 
    
     % SAVE       
    fprintf(file,'SAVE,Z_db,DB,,\r\n');
    fprintf(file,'FINISH      \n'); 
    
    %% SOL    
    fprintf(file,"/SOL \r\n");
    
    fprintf(file,"ANTYPE,0     \n") ;
    fprintf(file,"EQSLV,PCG,1E-8  \r\n");  

    fprintf(file,"LSSOLVE,1,3,1,   \r\n");
    fprintf(file,'FINISH      \n');    
    
    %% post
    
    % GET FROM ORIGINAL PROBLEM
    fprintf(file,'/POST1\r\n'); 
    fprintf(file,'ALLSEL,ALL 							\r\n');  
    fprintf(file,'SET,FIRST \r\n');   
    
  
    % Volume
    fprintf(file,'etable, my_vol, volu \r\n'); 
    fprintf(file,'*VGET,element_volume,ELEM, ,ETAB,my_vol, , ,2\r\n');
    fprintf(file,'*CFOPEN,ElementVolume,dat\r\n');
    fprintf(file,'*VWRITE,element_volume(1)\r\n');
    fprintf(file,'%%.15e\r\n');
    fprintf(file,'*CFCLOS\r\n');

    % Centroid X
    
    fprintf(file,'ETABLE,cent_x,CENT,X  \r\n'); 
    fprintf(file,'*VGET,my_cent_x,ELEM, ,ETAB,cent_x, , ,2 \r\n'); 
    fprintf(file,'*CFOPEN,Centroid_x,dat \r\n'); 
    fprintf(file,'*VWRITE,my_cent_x(1) \r\n'); 
    fprintf(file,'%%.15e\r\n');
    fprintf(file,'*CFCLOS \r\n'); 
    
    % Centroid Y
    
    fprintf(file,'ETABLE,cent_y,CENT,Y  \r\n'); 
    fprintf(file,'*VGET,my_cent_y,ELEM, ,ETAB,cent_y, , ,2 \r\n'); 
    fprintf(file,'*CFOPEN,Centroid_y,dat \r\n'); 
    fprintf(file,'*VWRITE,my_cent_y(1) \r\n'); 
    fprintf(file,'%%.15e\r\n');
    fprintf(file,'*CFCLOS \r\n');  
    
    % Centroid Z    
    fprintf(file,'ETABLE,cent_z,CENT,Z  \r\n'); 
    fprintf(file,'*VGET,my_cent_z,ELEM, ,ETAB,cent_z, , ,2 \r\n'); 
    fprintf(file,'*CFOPEN,Centroid_z,dat \r\n'); 
    fprintf(file,'*VWRITE,my_cent_z(1) \r\n'); 
    fprintf(file,'%%.15e\r\n');
    fprintf(file,'*CFCLOS \r\n');    
    
    fprintf(file,'FINISH      \n');
    
    
    
    % GET RESULTS
    fprintf(file,'/POST1\r\n'); 
    for l_step=1:3
        for i=1:1%freq_steps
            
            
            fprintf(file,"SET,%f,%f,1,0, , ,  \r\n",l_step,i);
            
            
            file_result_name = ['_' num2str(l_step) '_' num2str(i)];
            
            % SENE
            fprintf(file,"ALLSEL,ALL \r\n");  
            fprintf(file,'etable, my_sene%s, sene \r\n',file_result_name);
            fprintf(file,'*VGET,strain_energy%s,ELEM, ,ETAB,my_sene%s, , ,2\r\n',file_result_name,file_result_name);
            fprintf(file,'*CFOPEN,SENE%s, dat \r\n',file_result_name);
            fprintf(file,'*VWRITE,strain_energy%s(1)\r\n',file_result_name);
            fprintf(file,'%%.25e\r\n');
            fprintf(file,'*CFCLOS\r\n'); 

            % displacement
            fprintf(file,"ALLSEL,ALL \r\n"); 
         	fprintf(file,'*DIM,ux_matrix%s,array,nnode_full,1,\r\n',file_result_name);
            fprintf(file,'*DO,i,1,nnode_full               \r\n') ;
            fprintf(file,'*get,ux_matrix%s(i),NODE,i,U,X\r\n',file_result_name);
            fprintf(file,'*enddo                      \r\n')  ; 

            fprintf(file,'*CFOPEN,UX%s, dat \r\n',file_result_name);
            fprintf(file,'*VWRITE,ux_matrix%s(1)\r\n',file_result_name);
            fprintf(file,'%%.25e\r\n');
            fprintf(file,'*CFCLOS\r\n');  

            fprintf(file,"ALLSEL,ALL \r\n"); 
         	fprintf(file,'*DIM,uy_matrix%s,array,nnode_full,1,\r\n',file_result_name);
            fprintf(file,'*DO,i,1,nnode_full               \r\n') ;
            fprintf(file,'*get,uy_matrix%s(i),NODE,i,U,Y\r\n',file_result_name);
            fprintf(file,'*enddo                      \r\n')  ; 

            fprintf(file,'*CFOPEN,UY%s, dat \r\n',file_result_name);
            fprintf(file,'*VWRITE,uy_matrix%s(1)\r\n',file_result_name);
            fprintf(file,'%%.25e\r\n');
            fprintf(file,'*CFCLOS\r\n');            
 
            fprintf(file,"ALLSEL,ALL \r\n"); 
         	fprintf(file,'*DIM,uz_matrix%s,array,nnode_full,1,\r\n',file_result_name);
            fprintf(file,'*DO,i,1,nnode_full               \r\n') ;
            fprintf(file,'*get,uz_matrix%s(i),NODE,i,U,Z\r\n',file_result_name);
            fprintf(file,'*enddo                      \r\n')  ; 

            fprintf(file,'*CFOPEN,UZ%s, dat \r\n',file_result_name);
            fprintf(file,'*VWRITE,uz_matrix%s(1)\r\n',file_result_name);
            fprintf(file,'%%.25e\r\n');
            fprintf(file,'*CFCLOS\r\n');  
            
             
        end        
    end
            fprintf(file,'FINISH      \n');

    
fclose(file);
 

end
