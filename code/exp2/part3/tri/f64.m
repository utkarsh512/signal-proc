% Author: Utkarsh Patel
% Experiment 2: Part 3.2.2
% Observing input and output spectrum for FIR with triangular window

N = 64;                  % window length
K = (N - 1) / 2;
Fs = 10000;             % sampling frequency
t = 0: 1 / Fs: (3 * N - 1) / Fs;
wc = pi / 2;            % this implies cut-off freq is Fs / 4
w1 = 2000;              % passband frequency
w2 = 4000;              % stopband frequency
x = [10 10] * sin(2 * pi * [w1 w2]' * t) + rand(size(t)); % constructed signal
hd = sincf(N, K, wc);   % desired time-domain LPF
win = mywin(N, K);      % my window
hn = hd.*win;           % practical FIR
f = (-(3 * N) / 2: ((3 * N) / 2 - 1)) * (Fs / (3 * N)); % frequency range for plot
x_f = fftshift(fft(x)); % DFT of constructed signal
y = filtfilt(hn, 1, x); % signal after filtering
y_f = fftshift(fft(y)); % DFT of filtered signal

subplot(2, 1, 1);
stem(f, abs(x_f));
title('Frequency transform before filtering');
xticks(floor(-Fs / 2000) * 1000 : 1000 : ceil(Fs / 2000) * 1000 );
xlabel('Frequency (Hz)');
ylabel('X(f)');
subplot(2, 1, 2);
stem(f, abs(y_f));
title('Frequency transform after filtering');
xticks(floor(-Fs / 2000) * 1000 : 1000 : ceil(Fs / 2000) * 1000 );
xlabel('Frequency (Hz)');
ylabel('Y(f)');

figure("Name", "SNR triangular window with N = " + string(N));
snr(y);


function hd = sincf(N, K, wc)
    % Generates truncated version of time-domain representation
    % of ideal low-pass filter
    hd = zeros(1, N);
    for i = 0: N - 1
        hd(i + 1) = sin(wc * (i - K)) / (pi * (i - K));
    end
end

function win = mywin(N, K)
  % Generate triangular window
  win = zeros(1, N);
  for i = 0: N - 1
      win(i + 1) = 1 - (2 * ((i - K) / (N - 1)));
  end
end
