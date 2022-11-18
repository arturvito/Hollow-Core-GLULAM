function build_update(void_elements)

file = fopen('ansys_update.mac', 'w');

    fprintf(file,'FINISH \r\n');
    fprintf(file,'/CLEAR,NOSTART\r\n');
    fprintf(file,'RESUME,Z_db,DB,,\r\n');   

    fprintf(file,'/PREP7\r\n');   
    fprintf(file,'ALLSEL,ALL\r\n');
    fprintf(file,'MPCHG,1,ALL\r\n');

    fprintf(file,'ALLSEL,ALL\r\n');   
    name1 = ['FLST,5,' num2str(length(void_elements)) ',2,ORDE,' num2str(length(void_elements)) '\r\n'];
    fprintf(file,name1);
    
    void_elements = num2cell(void_elements);
    void_elements =cellfun(@num2str,void_elements,'un',0);
    fprintf(file,'FITEM,5, %s\n',void_elements{:});
    fprintf(file,"ESEL,S, , ,P51X \r\n");     
    fprintf(file,'MPCHG,2,ALL\r\n');
    fprintf(file,'ALLSEL,ALL\r\n');   
   
    % SAVE       
    fprintf(file,'SAVE,Z_db,DB,,\r\n');
    fprintf(file,'FINISH      \n'); 
    % SOL    
    fprintf(file,"/SOL \r\n");
    
    fprintf(file,"ANTYPE,0     \n") ;
    fprintf(file,"EQSLV,PCG,1E-8  \r\n");  

    fprintf(file,"LSSOLVE,1,3,1,   \r\n");
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
