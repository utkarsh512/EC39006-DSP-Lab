% Author: Utkarsh Patel
% Experiment 2: Part 1.5
% Analysing frequency response of LPF constructed by blackmnan window

wc = pi / 2;           % Cut-off frequency of the FIR filter
w = -1 * pi: 0.01: pi; % frequency range

N = 8;                 % window length
K = (N - 1) / 2;

% truncated version of time-domain representation of 
% ideal low-pass filter
hd = sincf(N, K, wc);
win = mywin(N);     % my window
hn = hd.* win;         % pratical low-pass filter designed
figure("Name", "Blackmnan window with N = " + string(N));
freqz(hn, 1, w);

N = 64;                 % window length
K = (N - 1) / 2;

% truncated version of time-domain representation of 
% ideal low-pass filter
hd = sincf(N, K, wc);
win = mywin(N);     % my window
hn = hd.* win;         % pratical low-pass filter designed
figure("Name", "Blackmnan window with N = " + string(N));
freqz(hn, 1, w);

N = 512;                 % window length
K = (N - 1) / 2;

% truncated version of time-domain representation of 
% ideal low-pass filter
hd = sincf(N, K, wc);
win = mywin(N);     % my window
hn = hd.* win;         % pratical low-pass filter designed
figure("Name", "Blackmnan window with N = " + string(N));
freqz(hn, 1, w);

function hd = sincf(N, K, wc)
    % Generates truncated version of time-domain representation
    % of ideal low-pass filter
    hd = zeros(1, N);
    for i = 0: N - 1
        hd(i + 1) = sin(wc * (i - K)) / (pi * (i - K));
    end
end

function win = mywin(N)
    % Generate black window
    win = zeros(1, N);
    for i = 0: N - 1
        win(i + 1) = 0.42 - (0.5 * cos((2 * pi * i) / (N - 1))) + (0.8 * cos((4 * pi * i) / (N - 1)));
    end
end