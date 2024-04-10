% TE356 - Sistemas de Comunicações Óticas e Sem Fio
% Análise de Dados de Potência Recebida no Rádio LoRa
% Modelagem de Perda de Percurso

close all; clc; clear all;

medidas20m = load("dados_outdoor_20m_modo1.txt");
medidas20m = medidas20m(:,2)';  
dist20 = 20 * ones(1, length(medidas20m));

medidas40m = load("dados_outdoor_40m_modo1.txt");
medidas40m = medidas40m(:,2)';
dist40 = 40 * ones(1, length(medidas40m));

medidas60m = load("dados_outdoor_60m_modo1.txt");
medidas60m = medidas60m(:,2)';
dist60 = 60 * ones(1, length(medidas60m));

medidas80m = load("dados_outdoor_80m_modo1.txt");
medidas80m = medidas80m(:,2)';
dist80 = 80 * ones(1, length(medidas80m));

medidas100m = load("dados_outdoor_100m_modo1.txt");
medidas100m = medidas100m(:,2)';
dist100 = 100 * ones(1, length(medidas100m));

medidas120m = load("dados_outdoor_120m_modo1.txt");
medidas120m = medidas120m(:,2)';
dist120 = 120 * ones(1, length(medidas120m));

medidas140m = load("dados_outdoor_140m_modo1.txt");
medidas140m = medidas140m(:,2)';
dist140 = 140 * ones(1, length(medidas140m));

medidas160m = load("dados_outdoor_160m_modo1.txt");
medidas160m = medidas160m(:,2)';
dist160 = 160 * ones(1, length(medidas160m));

medidas180m = load("dados_outdoor_180m_modo1.txt");
medidas180m = medidas180m(:,2)';
dist180 = 180 * ones(1, length(medidas180m));

medidas200m = load("dados_outdoor_200m_modo1.txt");
medidas200m = medidas200m(:,2)';
dist200 = 200 * ones(1, length(medidas200m));

medidas250m = load("dados_outdoor_250m_modo1.txt");
medidas250m = medidas250m(:,2)';
dist250 = 250 * ones(1, length(medidas250m));

medidas330m = load("dados_outdoor_330m_modo1.txt");
medidas330m = medidas330m(:,2)';
dist330 = 330 * ones(1, length(medidas330m));

plot(dist20, medidas20m, 'b*'); hold on; 
plot(dist40, medidas40m, 'b*');
plot(dist60, medidas60m, 'b*');
plot(dist80, medidas80m, 'b*');
plot(dist100, medidas100m, 'b*');
plot(dist120, medidas120m, 'b*');
plot(dist140, medidas140m, 'b*');
plot(dist160, medidas160m, 'b*');
plot(dist180, medidas180m, 'b*');
plot(dist200, medidas200m, 'b*');
plot(dist250, medidas250m, 'b*');
plot(dist330, medidas330m, 'b*');

%Parte 2
Pt = 0;
Gt = 1;
Gr = 1;

distances = [20 : 330];

lambda = 3e8 / 868e6;
PL = 10 * log10((4 * pi * distances./lambda).^2);
Pr=Pt + Gt +Gr - PL;

plot(distances, Pr, 'r-'); 
title("Modo 1 de operação do rádio LoRa; Free Space Propagation Curve");
xlabel("distância (m)");
ylabel("potência recebida (RSSI)");
axis([0 350 -95 -65]);
