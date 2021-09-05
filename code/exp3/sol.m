% Author: Utkarsh Patel (18EC30048)
% Experiment 3 - Encoding and decoding using bandpass filters

M = ['1' ,'2' ,'3' ,'A' ; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; % Available keys
X = categorical({'697', '770', '852', '941', '1209', '1336', '1477', '1633'});         % Encoding frequencies
X = reordercats(X, {'697', '770', '852', '941', '1209', '1336', '1477', '1633'});

SNR = 30; % SNR of encoded signal

for i = 1: 4
    for j = 1: 4
        input_key = M(i, j);
        x = Encode(input_key); % Encoding
        noizz = randn(size(x)) * std(x) / db2mag(SNR);
        x = x + noizz;
        [output_key, RMS] = Decode(x); % Decoding
        subplot(4, 4, 4 * (i - 1) + j);
        bar(X, RMS);
        xlabel("Frequency (Hz)");
        ylabel("RMS");
        title("Input Key: " + string(input_key) + ", Output Key: " + string(output_key));
    end
end


function [key, RMS] = Decode(x)
% Returns the key after decoding the signal 'x'
    M = ['1' ,'2' ,'3' ,'A' ; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; % list of available keys
    freq_col = [1209, 1336, 1477, 1633]; % Encoding frequency as per the column
    freq_row = [697, 770, 852, 941];     % Encoding frequency as per the row
    Fs = 4000; % Sampling frequency
    N = 2048 * 10;
    
    RMS = zeros(1, 8);
    
    row = 0; % to-be-decoded row index of key
    col = 0; % to-be-decoded col index of key
    rowmax = 0; % maximum of the energies of freq in freq_row in encoded signal x
    colmax = 0; % maximum of the energies of freq in freq_col in encoded signal x
    
    % Decoding the row index of key from x
    for i = 1: 4
        fil = BPFil(N, 5, freq_row(i) / Fs); % bandpass filter 
        y = conv(fil, x);
        RMS(i) = rms(y);
        if rms(y) > rowmax
            rowmax = rms(y);
            row = i;
        end
    end
    
    % Decoding the col index of key from x
    for i = 1: 4
        fil = BPFil(N, 5, freq_col(i) / Fs); % bandpass filter
        y = conv(fil, x);
        RMS(4 + i) = rms(y);
        if rms(y) > colmax
            colmax = rms(y);
            col = i;
        end
    end
    
    key = M(row, col);
end


function x = Encode(key)
% Returns the encoded signal for passed key
    M = ['1' ,'2' ,'3' ,'A' ; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; % list of available keys
    freq_col = [1209, 1336, 1477, 1633]; % Encoding frequency as per the column
    freq_row = [697, 770, 852, 941];     % Encoding frequency as per the row
    Fs = 4000; % Sampling frequency
    N = 2048 * 10;
    t = 0: 1 / Fs: (N - 1) / Fs; % time range
    x = 0;
    for i = 1: 4
        for j = 1: 4
            if M(i, j) == key
                x = cos(2 * pi * freq_row(i) * t) + cos(2 * pi * freq_col(j) * t);
            end
        end
    end
end
            

function fil = BPFil(N, b, wc)
% Bandpass filter design
    fil = zeros(1, N);
    for i = 0: N - 1
        fil(i + 1) = b * cos(2 * pi * wc * i);
    end
end
    