% Author: Utkarsh Patel
% Experimet 6

[y, Fs] = audioread('audio.wav'); % reading the audio signal

N = length(y); % length of the signal

bpf = [10 4000 0 0 0; 10 1500 4000 0 0; 10 800 1500 4000 0; 10 800 1500 2500 4000];
% matrix containing frequency required for constructing filters 

lpf = [16 50 160 500]; % envelope cut-off frequency

nbpf = 4; % change this to alter number of frequency bands

recon = containers.Map({'1', '2', '3', '4'}, {[], [], [], []});
% map object for storing envelopes for all the four envelope cut-off frequency

for r = 1: 4 % choosing the envelope cut-off freq
    x = 0;   % variable to store envelope
    n=randn(1,N); % white noise
    s=zeros(1,N); % variable to store reconstructed signal
    for i = 1: nbpf
        [b, a] = butter(4, [bpf(nbpf, i) / Fs, bpf(nbpf, i + 1) / Fs], 'bandpass');
        yfilt=filter(b,a,y); % filtering signal for given passband
        nfilt=filter(b,a,n); % filtering noise for given passband
        env = abs(hilbert(yfilt)); % extracting envelope 
        [b1, a1] = butter(4, lpf(r) /Fs, 'low');
        env = filter(b1, a1, env); % filtering envelope
        x = x + env;               % summing envelope
        env=transpose(env);
        s=s+(env.*nfilt);          % modulating noise with envelope
    end
    
    recon(string(r)) = [recon(string(r)); x]; % storing envelope to map object
    [b, a] = butter(4, 4000 / Fs, 'low');
    s = filter(b, a, s);  % low-passing reconstructed signal
    
    
    figure;

    subplot(2, 2, 1);
    plot(y);
    title('Original signal (time domain)');
    xlabel('Samples');
    ylabel('y[n]');

    subplot(2, 2, 2);
    dF = Fs/N;    
    f = -Fs/2:dF:Fs/2-dF;
    Y = fftshift(fft(y));
    plot(f,abs(Y)/N);
    title('Original signal (frequency domain)');
    xlabel('Frequency (in hertz)');
    ylabel('X(f)');

    subplot(2, 2, 3);
    plot(s);
    title('Reconstructed signal (Envelope lowpassed at ' + string(lpf(r)) + 'Hz)');
    xlabel('Samples');
    ylabel('s[n]');

    subplot(2, 2, 4);
    dF = Fs/N;    
    f = -Fs/2:dF:Fs/2-dF;
    S = fftshift(fft(s));
    plot(f,abs(S)/N);
    title('Reconstructed signal (frequency domain)');
    xlabel('Frequency (in hertz)');
    ylabel('X(f)');
end

figure;

for r = 1: 4
    subplot(2, 2, r);
    plot(recon(string(r)));
    title('Envelope lowpassed at ' + string(lpf(r)) + 'Hz');
    xlabel('Samples')
    ylabel('Amplitude')
end

