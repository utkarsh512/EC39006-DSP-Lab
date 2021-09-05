% Author: Utkarsh Patel (18EC30048)
% Experiment - 1 Part B-1
% DFT of the given signal with sampling frequency of 8 KHz

Fs = 8000; % sampling frequency

% for N = 64
[f, y] = foo(Fs, 64);
subplot(3, 1, 1);
stem(f, y);
xticks(-Fs / 2 : 1000 : Fs / 2);
title('DFT with Fs = 8 KHz and N = 64');
xlabel('Frequency (Hz)');
ylabel('X(f)')

% for N = 128
[f, y] = foo(Fs, 128);
subplot(3, 1, 2);
stem(f, y);
xticks(-Fs / 2 : 1000 : Fs / 2);
title('DFT with Fs = 8 KHz and N = 128');
xlabel('Frequency (Hz)');
ylabel('X(f)')

% for N = 256
[f, y] = foo(Fs, 256);
subplot(3, 1, 3);
stem(f, y);
xticks(-Fs / 2 : 1000 : Fs / 2);
title('DFT with Fs = 8 KHz and N = 256');
xlabel('Frequency (Hz)');
ylabel('X(f)')

function [f, y] = foo(Fs, N)
    % Function to generate DFT of the given signal
    % Inputs:
    % Fs : Sampling frequency
    % N : Dimension of DFT
    % Outputs:
    % f : Frequency range of DFT
    % y : DFT itself
    t = 0 : 1 / Fs : 0.1;
    x = 10 * cos(2 * pi * 1000 * t) + 6 * cos(2 * pi * 2000 * t) + 2 * cos(2 * pi * 4000* t);
    f = -Fs / 2 : Fs / (N - 1) : Fs / 2;
    y = fftshift(abs(fft(x, N)));
end

