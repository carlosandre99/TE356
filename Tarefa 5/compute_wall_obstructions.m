function number_of_obstructions=compute_wall_obstructions(area_width,area_height,wall_v,wall_h,signal_path_matrix)

[l,c]=size(wall_v);

number_of_obstructions_v=0;

for i=1:l

wall_matrix=compute_path_matrix(area_width,area_height,wall_v(i,1),wall_v(i,2),wall_v(i,3),wall_v(i,4));
wall_matrix_final=signal_path_matrix+wall_matrix;

if (sum(sum(wall_matrix_final==2))>=1)
    number_of_obstructions_v=number_of_obstructions_v+1;
end

end

[l,c]=size(wall_h);

number_of_obstructions_h=0;

for i=1:l

wall_matrix=compute_path_matrix(area_width,area_height,wall_h(i,1),wall_h(i,2),wall_h(i,3),wall_h(i,4));
wall_matrix_final=signal_path_matrix+wall_matrix;

if (sum(sum(wall_matrix_final==2))>=1)
    number_of_obstructions_h=number_of_obstructions_h+1;
end

end

number_of_obstructions=number_of_obstructions_v+number_of_obstructions_h;

