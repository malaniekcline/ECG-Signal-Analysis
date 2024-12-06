%% Malanie Cline - ECG Project %%
clc; 
clear;

%% ECG Signal 205
figure(1)
plotATM('219m'); 
title('Original ECG For 219m'); 
xlabel('Time (seconds)'); 
ylabel('Amplitude');

%% Remove DC Bias and Wander using Band-Pass Filter 
fs = 360; % from info file
fc = [0.5 50]; % standard for ECG

% Butterworth Band-Pass Filter
[b, a] = butter(3, fc/(fs/2));

load('205m.mat');
ECG_no_DC = filtfilt(b, a, val);

% Plotting ECG without DC Bias
t = (0:length(val)-1) / fs; % time scale for plot
% Still considerably noisy
figure(2);
plot(t, ECG_no_DC); % very high peaks could be caused from electrical interference/muscle artifacts/electrode issues

%% Median Filter
% For non-gaussian noises
ECG_med_filtered = medfilt1(ECG_no_DC, round(fs*0.2));

figure(3);
plot(t, ECG_med_filtered);

%% Detrend
ECG_detrended = detrend(ECG_med_filtered); 
figure(4);
plot(t, ECG_detrended);

%% Finding The Peaks
min_peak_height = 0.1; 
min_peak_dist = fs * 0.5;

[peaks, locations] = findpeaks(ECG_detrended, 'MinPeakHeight', min_peak_height, 'MinPeakDistance', min_peak_dist);
disp(length(peaks));

% Plotting the peaks
t = (0:length(ECG_detrended)-1)/fs;
figure(5);
plot(t, ECG_detrended);
hold on;
plot(t(locations), peaks, 'rv', 'MarkerFaceColor', 'r'); title('ECG Signal 205');
xlabel('Time (seconds)');
ylabel('Amplitude');
hold off;
