% Author: Utkarsh Patel (18EC30048)
% Experiment 4 - Part 2

N = 128; % length of white noise
w = -1 * pi: 0.01: pi;

mean = 0; % mean of noise
var = 1;  % variance of noise

h = TF(N); % transfer function of system

h_f = var * abs(freqz(h, 1, w)).^2; % expected PSD of x(n)
subplot(2, 1, 1);
plot(w, h_f);
xticks([-pi -pi/2 0 pi/2 pi]);
xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
title('Theoretical PSD of sequence x(n)');
xlabel('Frequency (\omega)');
ylabel('PSD');

rng('default');
r = normrnd(mean,sqrt(var),[1 N]); % white noise
% Generating output sequence x(n)
x = conv(h, r);
x = x(1: N);

% Vary p to change pole order
AR(x, N, 3)

function AR(x, N, p)
    % Computing the AR model of order p
    w = -1 * pi: 0.01: pi;
    R = zeros(1, N); % auto-correlation of x
    assert(p < N);
    for i = 0: p
        for j = 0: N - i - 1
            R(i + 1) = R(i + 1) + x(j + 1) * x(j + i + 1);
        end
        R(i + 1) = R(i + 1) / N;
    end
    A = zeros(p, p);
    b = zeros(p, 1);
    for i = 1: p
        b(i) = -R(i + 1);
    end
    idx = 0;
    for i = 0: p - 1
        for j = 0: p - 1
            A(i + 1, j + 1) = R(abs(idx - j) + 1);
        end
        idx = idx + 1;
    end
    C = linsolve(A, b);
    var_ = R(1);
    for i = 1: p
        var_ = var_ + C(i) * R(i + 1);
    end
    den = zeros(1, p + 1);
    den(1) = 1;
    for i = 1: p
        den(i + 1) = C(i);
    end
    P = abs(freqz(den, 1, w)).^2;
    P = var_ ./ P;
    subplot(2, 1, 2);
    plot(w, P);
    xticks([-pi -pi/2 0 pi/2 pi]);
    xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
    title('PSD of sequence x(n) using AR with p = ' + string(p));
    xlabel('Frequency (\omega)');
    ylabel('PSD');
end



function h = TF(N)
    % transfer function of system
    h = zeros(1, N);
    for n = 0: N - 1
        h(n + 1) = (9/10)^n/2 + (-9i/10)^n*(1/4 + 1i/4) + (9i/10)^n*(1/4 - 1i/4);
    end
end