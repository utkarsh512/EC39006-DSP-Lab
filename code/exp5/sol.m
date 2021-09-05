N = 20;    % order of adaptive filter
f = 10000; % change frequency here

Plot(f, N);

function Plot(f, N)
    % plots characteristics for filter order N
    % with signal having sinusoid with frequency f
    Fs = 4 * f;
    t = (0: 1: 10000) * (1 / Fs);
    noise = normrnd(0, 1, 1, length(t)); % noise
    a = 2 * sin(2 * pi * f * t); % sinusoid signal
    x = a + noise; % corrupted signal
    
    w = zeros(1,N+1); % adaptive filter
    
    y = zeros(1,N+1); % dummy variable
    z = zeros(1,N+1); % dummy variable
    i = 1;
    
    rerr = zeros(1, 20000);
    
    u = 0.0001; % learning rate
    eps = 0.001; % epsilon
    
    while(1)
        nz = zeros(1, N + 1);
        nz(1) = x(i);
        for j = 2: N + 1
            nz(j) = z(j - 1);
        end
        z = nz;
        y = sum(z.*w);
        e = y - x(i) ;
        w1 = w; % saving the previous value of w to w1
        w = w + u * z * e; % gradient descent
        w(1) = 0;
        rerr(i) = (norm(w - w1) / norm(w1));
        rerr(i) = rerr(i) * rerr(i);
        
        if rerr(i) < eps
            break;
        end
        
        i = i + 1;
    end
    w_ = -1 * pi: 0.001 * pi: pi;
    
    disp(rerr(1:i));
    
    subplot(2, 2, 1);
    plot(x(1:200));
    title('Before filtering: Corrupted signal containing sinusoid with F = ' + string(f) + ' sampled at Fs = ' + string(Fs));
    xlabel('Samples');
    ylabel('x(n)');
    
    subplot(2, 2, 2);
    plot(w_, abs(freqz(x, 1, w_)));
    xticks([-pi -pi/2 0 pi/2 pi]);
    xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
    title('Before filtering (frequency domain)');
    xlabel('Frequency (\omega)');
    ylabel('X(\omega)');
    x_f = conv(w, x);
    subplot(2, 2, 3);
    plot(x_f(1:200));
    title('After filtering: Corrupted signal containing sinusoid with F = ' + string(f) + ' sampled at Fs = ' + string(Fs));
    xlabel('Samples');
    ylabel('x(n)');
    
    subplot(2, 2, 4);
    plot(w_, abs(freqz(conv(w, x), 1, w_)));
    xticks([-pi -pi/2 0 pi/2 pi]);
    xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'});
    title('After filtering (frequency domain)');
    xlabel('Frequency (\omega)');
    ylabel('X(\omega)');
    
    figure;
    subplot(2, 1, 1);
    plot(rerr(1:i));
    title('Relative change in filter coefficients');
    xlabel('Iteration');
    ylabel('Relative error');
    set(gca, 'YScale', 'log');
end