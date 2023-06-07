
%Clear command window and workspace
clc;
clear;

% Load the sound file
[y, fs] = audioread('audio.wav');

% Design the low-pass filter
lpf = designfilt('lowpassfir', 'FilterOrder', 10001, 'CutoffFrequency', 500, 'SampleRate', fs);

% Design the band-pass filter
bpf = designfilt('bandpassfir', 'FilterOrder', 10001, 'CutoffFrequency1', 500, 'CutoffFrequency2', 4000, 'SampleRate', fs);

% Design the high-pass filter
hpf = designfilt('highpassfir', 'FilterOrder', 10001, 'CutoffFrequency', 4000, 'SampleRate', fs);

% Apply the low pass filter to the audio signal
kickSignal = filter(lpf, y);

% Apply the band pass filter to the audio signal
pianoSignal = filter(bpf, filter(bpf, y));

% Apply the low pass filter to the audio signal
cymbalSignal = filter(hpf, y);

% Save the filtered audio to a new WAV files
audiowrite('kick.wav', kickSignal, fs);
audiowrite('piano.wav', pianoSignal, fs);
audiowrite('cymbal.wav', cymbalSignal, fs);

%%%%%%% Generate waveform plots  %%%%%%%%%%%%%%%
time_original = linspace(0, (length(y)-1)/fs, length(y));
time_kick_signal = linspace(0, (length(kickSignal)-1)/fs, length(kickSignal));
time_piano_signal = linspace(0, (length(pianoSignal)-1)/fs, length(pianoSignal));
time_cymbal_signal = linspace(0, (length(cymbalSignal)-1)/fs, length(cymbalSignal));


figure
plot(time_original, y);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Original Signal Waveform');

figure
plot(time_kick_signal, kickSignal);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Kick Signal Waveform');

figure
plot(time_piano_signal, pianoSignal);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Piano Signal Waveform');

figure
plot(time_cymbal_signal, cymbalSignal);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Cymbal Signal Waveform');

%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%% Generate frequency responses %%%%%%%%%%%%%%%%%%

[h_lpf, w_lpf] = freqz(lpf); % Obtain the frequency response
[h_bpf, w_bpf] = freqz(bpf); % Obtain the frequency response
[h_hpf, w_hpf] = freqz(hpf); % Obtain the frequency response
freqz(lpf);

figure;
plot(w_lpf/pi*fs/2, 20*log10(abs(h_lpf))); % Plot magnitude response in dB
plot(w_lpf, h_lpf*fs);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Lowpass Filter - Magnitude Response');

figure;
plot(w_bpf/pi*fs/2, 20*log10(h_bpf)); % Plot magnitude response in dB
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Bandpass Filter - Magnitude Response');

figure;
plot(w_bpf/pi*fs/2, 20*log10(abs(h_bpf) + eps)); % Plot magnitude response in dB
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Highpass Filter - Magnitude Response');