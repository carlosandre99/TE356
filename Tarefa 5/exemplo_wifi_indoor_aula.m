
clear; clc; close all;

% ------------------------------------------------------------------------------------------------------
% Definição da Área de Cobertura (em pixels)
% ------------------------------------------------------------------------------------------------------

% Exemplo - 10 pixels/metro
area_width=500;    
area_height=500;  

step_grid=1;           % Passo de simulação em pixels (Controle de Complexidade/Velocidade)

a=1:step_grid:area_width;      area_width=a(end);
a=1:step_grid:area_height;     area_height=a(end);

%B = imresize(A, [NUMROWS NUMCOLS])

% ------------------------------------------------------------------------------------------------------
% Definições das Paredes em Metros - Escala de 10 pixels/metro
% ------------------------------------------------------------------------------------------------------
% Paredes Verticais
% Formato das Coordenadas = (x_inicial    y_inicial    x_final   y_final) 


wall_v= [ 3    12    3    36;
          9    12    9    36;
          18    12    18   24;
          27   12    27   18;
          27   30    27   36;
          36   12    36   36;
          45   12    45   36;

          ] ;

% Paredes Horizontais
wall_h= [ 3    12    45    12;
          27   18    36    18;
          27   30    36    30;
          18    24    24     24;
          3    36    45    36;
          ] ;


% Passa para a Escala de Pixels - 10 pixels/metro
wall_v=(wall_v*10);
wall_h=(wall_h*10);

[l,c]=size(wall_v);
wall_matrix_final=zeros(area_width,area_height);

for i=1:l

wall_matrix=compute_path_matrix(area_width,area_height,wall_v(i,1),wall_v(i,2),wall_v(i,3),wall_v(i,4));
wall_matrix_final=wall_matrix_final+wall_matrix;

end

figure(1)
imshow(wall_matrix_final)
%pause

[l,c]=size(wall_h);

for i=1:l

wall_matrix=compute_path_matrix(area_width,area_height,wall_h(i,1),wall_h(i,2),wall_h(i,3),wall_h(i,4));
wall_matrix_final=wall_matrix_final+wall_matrix;
%figure(2);  imshow(wall_matrix_final);

end

figure(1)
imshow(wall_matrix_final)
pause

% -----------------------------------------------------------------------------
% Teste das Obstruções
% -----------------------------------------------------------------------------

% Exemplo com 1 Obstrução
% x_ap=10;   y_ap=45;
% x=30;          y=35;

% Exemplo com 2 Obstruções
% x_ap=10;   y_ap=45;
% x=40;          y=35;

% Exemplo com 3 Obstruções
%x_ap=10;   y_ap=45;
%x=40;          y=15;

% Desnormalização
% Passa para a Escala de Pixels - 10 pixels/metro
%x_ap=x_ap*10;   y_ap=y_ap*10;
%x=x*10;   y=y*10;

%signal_path_matrix=compute_path_matrix(area_width,area_height,x_ap,y_ap,x,y);
%figure(2)
%imshow(wall_matrix_final+signal_path_matrix)
%number_of_obstructions=compute_wall_obstructions(area_width,area_height,wall_v,wall_h,signal_path_matrix);

%number_of_obstructions
%pause


% Desnormalização
% Passa para a Escala de Pixels - 10 pixels/metro
x_ap=23;   y_ap=28;
x_ap=x_ap*10;   y_ap=y_ap*10;

% ------------------------------------------------------------------------------------
% Dados do AP
% ------------------------------------------------------------------------------------
f=2.4835e9; 
Pt_dBm=20; % Potência de Transmissão em dBm
Gt=4; % Ganho da Antena Transmissora (dBi)
Gr=2; % Ganho da Antena Receptora (dBi)
n=2.5;  % Expoente de Perda de Percurso do Log-Distance
d0=1;   % Distancia de referencia
sigma2=5;  % Variancia do Sombreamento

% ------------------------------------------------------------------------------------
% Dados do AP
% ------------------------------------------------------------------------------------
% f=865.2e6;
% Pt_dBm=0;
% Gt_dBi=0;
% Gr_dBi=0;
% n=2;                % Expoente de Perda de Percurso do Log-Distance
% d0=1;             % Distancia de referencia
% sigma2=15;  % Variancia do Sombreamento

c=3e8; lambda=c/f;  % Comprimento de Onda

% Perda de Percurso na Distancia de Referencia
PL_d0_dB=10*log10((4*pi*d0/lambda)^2);  

%y=0:step_grid:area_height-step_grid;
%x=0:step_grid:area_width-step_grid;

y=1:area_height;
x=1:area_width;

Pr_dBm=zeros(length(y),length(x));
Taxa=zeros(length(y),length(x));

%Pr_dBm=-1.*ones(length(y),length(x));
%Taxa=-1.*ones(length(y),length(x));

total_steps=length([1:step_grid:length(x)])*length([1:step_grid:length(y)]);
step=1;

for i=1:step_grid:length(y)
    for j=1:step_grid:length(x)
        
        [step total_steps]
        step=step+1;
        
        % Calcula Distancia em Pixels
        d=sqrt((x(j)-x_ap)^2+(y(i)-y_ap)^2);
        
        % Calcula Distancia em Metros (8.6 pixels/metro)
         d=d./10;
        
        % Efeito de Sombreamento
        XdB=sqrt(sigma2)*randn;  
        %XdB=0;   % Sem Sombreamento
        
        PL_d_dB=PL_d0_dB+10.*n.*log10(d/d0)+XdB;      % Log-Distance+Sombreamento
       
        signal_path_matrix=compute_path_matrix(area_width,area_height,x_ap,y_ap,x(j),y(i));
        
        number_of_obstructions=compute_wall_obstructions(area_width,area_height,wall_v,wall_h,signal_path_matrix);
         
        % Perda Total das Obstruções (Paredes) - 6dB/parede de tijolos
        PL_Wall_dB=6.*number_of_obstructions;
        
        
        % ----------------------------------------------------------------
        % Potências Recebidas para d<d0
        % ----------------------------------------------------------------
        if (d>d0)
            Pr_dBm(i,j)=Pt_dBm+Gt+Gr-PL_d_dB-PL_Wall_dB;
        else
            Pr_dBm(i,j)=Pt_dBm+Gt+Gr-PL_d0_dB-PL_Wall_dB;
        end
        
        

        if Pr_dBm(i,j) >= -71
            Taxa(i,j) = 300;
        elseif Pr_dBm(i,j) >= -75 && Pr_dBm(i,j) < -71
            Taxa(i,j) = 150;
        elseif Pr_dBm(i,j) >= -78 && Pr_dBm(i,j) < -75
            Taxa(i,j) = 54;
        elseif Pr_dBm(i,j) >= -93 && Pr_dBm(i,j) < -78
            Taxa(i,j) = 11;
        elseif Pr_dBm(i,j) >= -92 && Pr_dBm(i,j) < -78
            Taxa(i,j) = 6;
        elseif Pr_dBm(i,j) >= -96 && Pr_dBm(i,j) < -92
            Taxa(i,j) = 1;
        end
        
        
         if (j>1)
            Pr_dBm(i,j-step_grid+1:j-1)= Pr_dBm(i,j);
            Taxa(i,j-step_grid+1:j-1)= Taxa(i,j);     
        end
        if (i>1)
            Pr_dBm(i-step_grid+1:i-1,j)= Pr_dBm(i,j);
            Taxa(i-step_grid+1:i-1,j)= Taxa(i,j);  
        end
        
    end
end


%Pr_dBm(1:10,1:10)
%pause

% -----------------------------------------------------------------
% Ajuste de Zeros na Matriz de Potência e Taxa
% -----------------------------------------------------------------
for i=1:length(y)
    for j=step_grid+1:step_grid:length(x)
            Pr_dBm(i,j-step_grid+1:j-1)= Pr_dBm(i,j);
            Taxa(i,j-step_grid+1:j-1)= Taxa(i,j);
    end
end

xx=1:length(x);
yy=1:length(y);

figure(7)
surface(xx,yy,flipud(Pr_dBm),'FaceColor','interp')
shading interp
colormap(gca,'jet');
%colormap(flipud(colormap))
colorbar

hold
draw_scenario(area_width,area_height,wall_v,wall_h)


figure(8)
surface(xx,yy,flipud(Taxa),'FaceColor','interp')
shading interp
colormap(gca,'jet');
colorbar

hold
draw_scenario(area_width,area_height,wall_v,wall_h)


