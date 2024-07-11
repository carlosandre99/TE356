clc; clear all; close all;

% Roteiro de Simulação para o Canal AWGN
SNR_dB = -5:1:35;
SNR_linear = 10.^(SNR_dB/10);

Pb_AWGN = 0.5 * erfc(sqrt(SNR_linear));
Pb_Rayleigh = 0.5 * (1 - sqrt(SNR_linear ./ (1 + SNR_linear)));

figure;
semilogy(SNR_dB, Pb_AWGN, 'b');
hold on;
semilogy(SNR_dB, Pb_Rayleigh, 'r');
grid on;
xlabel('SNR (dB)');
ylabel('Probabilidade de Erro de Bit (BER)');
title('SNR vs BER para Modulação BPSK');
legend('Canal AWGN', 'Canal Rayleigh');
axis([-5 35 1e-5 1]);
hold off;

% Simulação de BER para Modulação BPSK no Canal AWGN
SNR_dB_AWGN = 0:1:10;
num_bits = 1e6;

BER_AWGN_sim = zeros(length(SNR_dB_AWGN), 1);

for idx = 1:length(SNR_dB_AWGN)
    SNR_linear = 10^(SNR_dB_AWGN(idx) / 10);
    
    Es = 1;  
    N0 = Es / SNR_linear;
    noise_variance = N0 / 2;
    
    bits = randi([0 1], num_bits, 1);
    symbols = 2*bits - 1;  

    noise = sqrt(noise_variance) * randn(num_bits, 1);

    received_signal = symbols + noise;

    detected_bits = received_signal > 0;

    num_errors = sum(bits ~= detected_bits);
    BER_AWGN_sim(idx) = num_errors / num_bits;
end

% Plot da simulação para o canal AWGN
figure;
semilogy(SNR_dB_AWGN, BER_AWGN_sim, 'b');
hold on;
semilogy(SNR_dB_AWGN, 0.5 * erfc(sqrt(10.^(SNR_dB_AWGN / 10))), 'r');
grid on;
xlabel('SNR (dB)');
ylabel('Probabilidade de Erro de Bit (BER)');
title('Simulação de BER para Modulação BPSK no Canal AWGN');
legend('Simulação AWGN', 'Teórico AWGN');
axis([0 10 1e-5 1]);
hold off;

% Simulação de BER para Modulação BPSK no Canal Rayleigh
SNR_dB = -5:1:35;
num_blocks = 100;
block_size = num_bits / num_blocks;

BER_Rayleigh_sim = zeros(length(SNR_dB), 1);

for idx = 1:length(SNR_dB)
    SNR_linear = 10^(SNR_dB(idx) / 10);
    
    Es = 1;  
    N0 = Es / SNR_linear;
    noise_variance = N0 / 2;
    
    num_errors_total = 0;

    for block_idx = 1:num_blocks
      
        bits = randi([0 1], block_size, 1);
        symbols = 2*bits - 1;  

        h = (randn(block_size, 1) + 1i*randn(block_size, 1)) / sqrt(2);

        noise = sqrt(noise_variance) * (randn(block_size, 1) + 1i*randn(block_size, 1)) / sqrt(2);

        received_signal = h .* symbols + noise;

        equalized_signal = received_signal ./ h;

        detected_bits = real(equalized_signal) > 0;

        num_errors = sum(bits ~= detected_bits);
        num_errors_total = num_errors_total + num_errors;
    end

    BER_Rayleigh_sim(idx) = num_errors_total / num_bits;
end

BER_AWGN = qfunc(sqrt(2 * 10.^(SNR_dB / 10)));
BER_Rayleigh_theory = 0.5 * (1 - sqrt(10.^(SNR_dB / 10) ./ (1 + 10.^(SNR_dB / 10))));

figure;
semilogy(SNR_dB, BER_Rayleigh_sim, 'r');
hold on;
semilogy(SNR_dB, BER_AWGN, 'b');
semilogy(SNR_dB, BER_Rayleigh_theory, 'm');
grid on;
xlabel('SNR (dB)');
ylabel('Probabilidade de Erro de Bit (BER)');
title('Simulação de BER para Modulação BPSK no Canal Rayleigh');
legend('Simulação Rayleigh', 'Teórico AWGN', 'Teórico Rayleigh');
axis([-5 35 1e-5 1]);
hold off;

% Modulação 8-QAM
SNR_dB_8QAM = -5:1:35;
SNR_8QAM = 10.^(SNR_dB_8QAM/10);
Pb_8QAM = 7/8 * erfc(sqrt(3/(8^2-1)*SNR_8QAM));

figure;
semilogy(SNR_dB_8QAM, Pb_8QAM, 'b');
hold on;
semilogy(SNR_dB, Pb_AWGN, 'r');
semilogy(SNR_dB, Pb_Rayleigh, 'm');
grid on;
xlabel('Relação sinal-ruído (Eb/N0) em dB');
ylabel('Probabilidade de erro de símbolo (Pb)');
legend('8-QAM', 'Canal AWGN', 'Canal Rayleigh');
title('Curva teórica de desempenho da modulação 8-QAM');
axis([-5 35 1e-5 1]);
hold off;