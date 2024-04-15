function path_matrix=compute_path_matrix(area_width,area_height,x_ap,y_ap,x_client,y_client)

area_matrix=zeros(area_width,area_height);

[xm,ym]=size(area_matrix);

area_matrix(y_ap,x_ap)=1;
area_matrix(y_client,x_client)=1;

dx=(x_client-x_ap);
dy=(y_client-y_ap);

if (abs(dx)>=abs(dy))
    step=abs(dx);
else
    step=abs(dy);
end

dx=dx/step;
dy=dy/step;

x = x_ap;
y = y_ap;
i = 1;

while (i<=step)
    area_matrix(round(y),round(x))=1;
           
    x = x + dx;
    y = y + dy;
    i = i + 1;
    
end

path_matrix=area_matrix;
