% TE356- Sistemas de Comunicações Óticas e Sem Fio
% Tarefa 4- Modulações Digitais- Simulação Canal AWGN

clear all; clc; close all;

% Modulação BPSK
SNR_dB = -2:0.5:15;
SNR = 10.^(SNR_dB/10);
Pb = (1/2)*erfc(sqrt(SNR));

figure;
semilogy(SNR_dB, Pb);
hold on;

xlabel('Relação sinal-ruído (SNR) em dB');
ylabel('Probabilidade de erro de símbolo (Pb)');
title('Curva teórica de desempenho da modulação BPSK');

% Valores de Eb/N0 para simulação
EbN0_bpsk = [2 5 8 10];
% Define o número de iterações e símbolos
numIter_bpsk = 100;
N_bpsk = 10^5;
% Simula a BER para cada valor de Eb/N0
ber_bpsk = MonteCarlo2ASK(EbN0_bpsk, numIter_bpsk, N_bpsk);

% Plot dos resultados BPSK simulados
semilogy(EbN0_bpsk, ber_bpsk, 'o-');
legend('BPSK - Teórico', 'BPSK - Simulado');

hold off;

% Modulação 8ASK
SNR_dB_8ask = -2:0.5:15;
SNR_8ask = 10.^(SNR_dB_8ask/10);
Pb_8ask = 7/8 * erfc(sqrt(3/(8^2-1)*SNR_8ask));

figure;
semilogy(SNR_dB_8ask, Pb_8ask);
hold on;

xlabel('Relação sinal-ruído (Eb/N0) em dB');
ylabel('Probabilidade de erro de símbolo (Pb)');
title('Curva teórica de desempenho da modulação 8ASK');

% Valores de Eb/N0 para simulação
EbN0_8ask = [0 5 10 15];
% Define o número de iterações e símbolos
numIter_8ask = 10^4;
N_8ask = 10^5;

% Simula a SER para cada valor de Eb/N0
ser_8ask = MonteCarlo8ASK(EbN0_8ask, numIter_8ask, N_8ask);
% Converte SER para BER
ber_8ask = ser_8ask/log2(8);

% Plot dos resultados 8ASK simulados
plot(EbN0_8ask, ser_8ask, 'o-');
legend('8ASK - Teórico', '8ASK - Simulado');

Curva_teorica_e_simulacao_16QAM(); % Chamada a função 16-QAM

function ber = MonteCarlo2ASK(EbN0, numIter, N)
    ber = zeros(size(EbN0));
    for k=1:length(EbN0)
        erro_total = zeros(1, numIter);
        for i=1:numIter
            % Gera os bits aleatórios
            bits = randi([0 1], 1, N);
            % Mapeia os bits para símbolos BPSK
            symb = 2*bits - 1;
            SNR = 10^(EbN0(k)/10);
            % Calcula a variância do ruído AWGN
            sigma_sq = 1/(2*SNR);
            % Gera o ruído AWGN 
            n = sqrt(sigma_sq)*(randn(1, N) + 1i*randn(1, N));
            % Simula a recepção de um símbolo
            r = symb + n;
            % Detecta os bits recebidos
            bitsRx = real(r) > 0;
            % Conta o erro
             erro = sum(bits ~= bitsRx)/N;
            % erro = sum(bits ~= bitsRx) / (N * log2(2));
            erro_total(i) = erro;
        end
        ber(k) = mean(erro_total);
    end
end

function ser = MonteCarlo8ASK(EbN0, numIter, N)
    ser = zeros(size(EbN0));
    const = [-7 -5 -3 -1 1 3 5 7];
    Es = mean(const.^2); % Calcula a energia média por símbolo
    symb = const/sqrt(Es); % Normaliza a constelação para Eb/N0 = 1

    % Loop para cada valor de Eb/N0
    for k=1:length(EbN0)
        erro_total = zeros(1, numIter);
        SNR = 10.^(EbN0(k)/10);
        sigma_sq = 1 / (2*SNR);
        sigma = sqrt(sigma_sq);
        for i=1:numIter
            ind = randi(8);
            simbolo_constelacao = symb(ind);
            % Gera o ruído AWGN
            noise = randn * sigma; 
            % Simula a recepção de um símbolo
            simbolo_noise = simbolo_constelacao + noise; 
            % Detecta o símbolo recebido
            [~, ind2] = min(abs(symb - simbolo_noise)); 
            simbolo_recebido = symb(ind2);
            % Conta o erro
            if (simbolo_recebido ~= simbolo_constelacao)
                erro_total(i) = 1;
            end
        end
        ser(k) = mean(erro_total); % Calcula a SER
    end
end

function Curva_teorica_e_simulacao_16QAM()
    % Curva teórica 
    SNR_dB = -2:0.5:16;
    SNR = 10.^(SNR_dB/10);
    p = (1- 1/4)*erfc(sqrt(3/30*SNR));
    Ps = 1 - (1 - p).^2;
   

    % Simulação Monte Carlo 
    EB_N0_dB = [0 5 10 12];
    % Define a constelação 16-QAM
    Const_X = [-3 -1 1 3];
    Const_Y = [-3 -1 1 3];
    % Calcula a energia média por símbolo
    Es = mean(Const_X.^2 + Const_Y.^2);
    % Normaliza a constelação para Eb/N0 = 1
    Const_X_norm = Const_X./sqrt(Es);
    Const_Y_norm = Const_Y./sqrt(Es);
    % Gera os símbolos aleatórios entre 1 e 4
    Const_X_data = randi(4, 100000, 1);
    Const_Y_data = randi(4, 100000, 1);
    erro = zeros(1, length(EB_N0_dB));

    % Loop para cada valor de Eb/N0
    for snr_index = 1:length(EB_N0_dB)
        EB_N0_dB_current = EB_N0_dB(snr_index);
        EB_N0_current = 10^(EB_N0_dB_current/10);
        % Valores de desvio e padrão e variancia
        desvioPad = 1/(2*EB_N0_current);
        variancia = sqrt(desvioPad);
        Const_X_qam = zeros(100000, 1);
        Const_Y_qam = zeros(100000, 1);
        % Gera o ruído AWGN
        Ruido_X = randn(100000, 1)*variancia;
        Ruido_Y = randn(100000, 1)*variancia;
        X_rx = zeros(100000, 1);
        Y_rx = zeros(100000, 1);
        X_rx_quant = zeros(100000, 1);
        Y_rx_quant = zeros(100000, 1);

        for i = 1:100000
            Const_X_qam(i) = Const_X_norm(Const_X_data(i));
            Const_Y_qam(i) = Const_Y_norm(Const_Y_data(i));
            % Simula a recepção de um símbolo
            % Ruído  que ao ser somadao com a constelação normalizadas 
            % em função dos valores sorteados, geram o sinal recebido
            X_rx(i) = Const_X_qam(i) + Ruido_X(i);
            Y_rx(i) = Const_Y_qam(i) + Ruido_Y(i);
        end

        % Quantiza os símbolos recebidos
        % Comparação entre os valores da modulação QAM, sem ruído, com os 
        % valores encontrados através da função quantalph
        X_rx_quant = quantalph(X_rx, Const_X_norm);
        Y_rx_quant = quantalph(Y_rx, Const_Y_norm);

        
        for k = 1:100000
            % Conta o erro
            % No caso desses valores serem diferentes, isso indica que foi 
            % obtido um erro, e isso é contabilizado através da variável erro
            % Para os dois eixos da constelação
            if (Const_X_qam(k) ~= X_rx_quant(k)) || (Const_Y_qam(k) ~= Y_rx_quant(k))
                erro(snr_index) = erro(snr_index) + 1;
            end
        end
        %  Taxa de erros de bits, com base na quantidade de erros e na quantidade
        % de interações, que no caso foi 100000
        BER(snr_index) = erro(snr_index) / 100000;
    end

    % Plotar curva teórica e simulada
    figure;
    semilogy(SNR_dB, Ps);
    hold on;
    semilogy(EB_N0_dB, BER, 'r*');
    title("Desempenho 16-QAM");
    xlabel("SNR[dB]");
    ylabel("BER");
    legend("teórica", "simulada");

    % Constelação de sinais do 16-QAM
    % Os pontos não ficam concentrados exatamente no mesmo ponto
    % Isso ocorre devido a variação de SNR, a qual é introduzida pela
    % inclusão de ruído na simulação
    figure;
    scatter(X_rx(1:1000), Y_rx(1:1000), '.');
    title("Constelação recebida (16-QAM)");
end

% Função para quantizar um símbolo
function y = quantalph(x, alphabet)
    [r, c] = size(alphabet);
    if c > r
        alphabet = alphabet';
    end
    [r, c] = size(x);
    if c > r
        x = x';
    end
    alpha = alphabet(:, ones(size(x)))';
    dist = (x(:, ones(size(alphabet))) - alpha).^2;
    [~, i] = min(dist, [], 2);
    y = alphabet(i);
end
