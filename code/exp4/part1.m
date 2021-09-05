% Author: Utkarsh Patel (18EC30048)
% Experiment 4 - Part 1

N = 128; % length of white noise
L = 8;   % components used
D = 4;   % overlapping within component
% D = f * (N / L), where f is percentage overlapping
M = N / L;% length of each component without overlapping
w = -1 * pi: 0.01: pi;

mean = 0; % mean of noise
var = 1;  % variance of noise

h = TF(N); % transfer function of system

h_f = var * abs(freqz(h, 1, w)).^2; 

rng('default');
r = normrnd(mean,sqrt(var),[1 N]); % white noise
% Generating output sequence x(n)
x = conv(h, r);
x = x(1: N);

win = ham(M); % hamming window
U = 0; % power of the window (to be used in normalization)
for i = 1: M
    U = U + win(i) * win(i);
end
U = U / M;

Pff = 0; % Overall PSD

for i = 0: L - 1
    x_ = zeros(1, M);
    for j = 0: M - 1
        x_(j + 1) = x(j + 1 + i * D) * win(j + 1);
    end
    Pff_i = abs(freqz(x_, 1, w)).^2;
    Pff_i = Pff_i / (M * U); % PSD of individual components
    Pff = Pff + Pff_i / L;
end

subplot(2, 1, 1);
plot(w, Pff);
xticks([-pi -pi/2 0 pi/2 pi]);
xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
title('Welch spectrum estimation of PSD of sequence x(n) (25% overlapping)');
xlabel('Frequency (\omega)');
ylabel('PSD');

D = 8;
Pff = 0; % Overall PSD

for i = 0: L - 1
    x_ = zeros(1, M);
    for j = 0: M - 1
        x_(j + 1) = x(j + 1 + i * D) * win(j + 1);
    end
    Pff_i = abs(freqz(x_, 1, w)).^2;
    Pff_i = Pff_i / (M * U); % PSD of individual components
    Pff = Pff + Pff_i / L;
end

subplot(2, 1, 2);
plot(w, Pff);
xticks([-pi -pi/2 0 pi/2 pi]);
xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
title('Welch spectrum estimation of PSD of sequence x(n) (50% overlapping)');
xlabel('Frequency (\omega)');
ylabel('PSD');


function win = ham(M)
    % hamming window of length M
    win = zeros(1, M);
    for i = 0: M - 1
        win(i + 1) = 0.54 - 0.46 * cos(2 * pi * (i) / (M - 1));
    end
end


function h = TF(N)
    % transfer function of system
    h = zeros(1, N);
    for n = 0: N - 1
        h(n + 1) = (4i/5)^n*(64/145 - 72i/145) + (9/10)^n*(81/145 + 72i/145);
    end
end