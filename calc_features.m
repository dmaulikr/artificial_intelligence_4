function [ln_e,ln_m,avg_z]=calc_features(filename, duration, ...
    window_time_length)
%
% function which calculates the features of a samples file.
% These features consist of the natural logarithm of the 
% average values for Energy and Magnitude and the average
% value for ZCR.
%
% params:
%
% filename: the path to the file which contains the samples
% duration: the duration of the audio file
% window_time_length: the time length of the window
%


file = fopen(filename);

% samples are integers separated by newline characters
samples = fscanf(file, '%d');

% the sample size
ssize = size(samples, 1);

% the sampling rate
srate = ssize / duration;

% the size of the window in number samples contained
window_sample_size = srate * window_time_length;

energy = zeros(ssize, 1);
magnitude = zeros(ssize, 1);
zcr = zeros(ssize, 1);

for n=1:ssize
    for k = n - window_sample_size + 1: n
        if k <= 0 | k > ssize
            sample = 0;
        else
            sample = samples(k);
        end    
        energy(n) = energy(n) + sample * sample;
        magnitude(n) = magnitude(n) + abs(sample);
        
        % calculating the sign of k-1
        if k - 1 <= 0 | k - 1 > ssize | samples(k - 1) >= 0
            previous_sign = 1;
        else
            previous_sign = 0;
        end
        
        if sample >= 0
            sign = 1;
        else
            sign = 0;
        end
        zcr(n) = zcr(n) + abs(sign - previous_sign);
    end
    zcr(n)  = zcr(n) / (2 * window_sample_size);
end

ln_e = log(mean(energy));
ln_m = log(mean(magnitude));
avg_z = mean(zcr);