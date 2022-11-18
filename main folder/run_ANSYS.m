function run_ANSYS(odir,filename)

if contains(filename,'first')
    file_name = '\ansys_in.mac" -b -o ';    
elseif contains(filename,'update')
    file_name =  '\ansys_update.mac" -b -o ';
elseif contains(filename,'post_processing')
    file_name =  '\ansys_in_post_processing.mac" -b -o ';
end

ansys.job_name = '"Z_db"';
newStr = odir;
newStr = strrep(newStr,'/','\');
newStr = strrep(newStr,'.','');

ansys.ansys_path = '"C:\Program Files\ANSYS Inc\v211\ansys\bin\winx64\MAPDL.exe"';
ansys.dir_path = ['"' pwd newStr '"'];
ansys.input_path = ['"' pwd];
ansys.output_path = ['"' pwd newStr ];

[status] = system([ansys.ansys_path ' -g -p mech_2 -dis -mpi INTELMPI -np 2 -lch -dir ' ansys.dir_path ' -j '...
           ansys.job_name ' -s read -l en-us -b -i '  ansys.input_path  file_name...
           ansys.output_path  '\Z_output.txt"' ]);

end
