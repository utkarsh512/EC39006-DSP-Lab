% Author: Utkarsh Patel (18EC30048)
% Experiment - 1 Part C (Run on MATLAB online)
% Analyzing spectrum of square wave

Fs = 20000;                % Sampling Frequency
f = 1000;                  % Frequency of square wave
N = 256;                   % Number of samples
t = 0 : 1/Fs : (N - 1)/Fs; % Time range
x = square(2*pi*f*t);      % Square wave
y = fft(x);                % DFT of square signal
z = fftshift(y);
frange = (-N/2 : N/2-1) * (Fs/N); % Frequency range for DFT
plot(frange, abs(z)/N);
title('Spectrum of a square wave');
xlabel('Frequency (Hz)');
ylabel('X(f) / N');