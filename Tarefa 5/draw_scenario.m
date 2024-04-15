function []=draw_scenario(area_width,area_height,wall_v, wall_h)

[l,c]=size(wall_v);

for i=1:l

plot([ wall_v(i,1),wall_v(i,3) ], [ area_height-wall_v(i,2),area_height-wall_v(i,4) ],'k');

end


[l,c]=size(wall_h);

for i=1:l

plot([ wall_h(i,1),wall_h(i,3) ], [ area_height-wall_h(i,2),area_height-wall_h(i,4) ],'k');

end


end