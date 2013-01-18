function plotai(filename, duration, window_time_length)

file = fopen(filename);

samples = fscanf(file, '%d');

ssize = size(samples, 1);

srate = ssize / duration;
time_axis = 1/srate:1/srate:duration;
time_axis = time_axis * 1000;

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
        %fprintf('sample for k=%d: %d\n', k, sample)
        energy(n) = energy(n) + sample * sample;
        magnitude(n) = magnitude(n) + abs(sample);
        
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

figure;

samples_norm = samples / max(samples);
energy_norm = energy / max(energy);
%fprintf('max energy %d\n', max(energy))   
plot(time_axis, samples_norm, 'b-', 'DisplayName', 'Signal (Normalized)'); hold on;
plot(time_axis, energy_norm, 'r-', 'DisplayName', 'Energy (Normalized)'); hold off;
xlabel('time (ms)')
ylabel('s[t], E[t]')
legend('show')
title('Energy')

figure;

magnitude_norm = magnitude / max(magnitude) ;
plot(time_axis, samples_norm, 'b-', 'DisplayName', 'Signal (Normalized)'); hold on;
plot(time_axis, magnitude_norm, 'r-', 'DisplayName', 'Magnitude (Normalized)'); hold off;
xlabel('time (ms)')
ylabel('s[t], M[t]')
legend('show')
title('Magnitude')

figure;

zcr_norm = zcr / max(zcr) ;
plot(time_axis, samples_norm, 'b-', 'DisplayName', 'Signal (Normalized)'); hold on;
plot(time_axis, zcr_norm, 'r-', 'DisplayName', 'ZCR (Normalized)'); hold off;
xlabel('time (ms)')
ylabel('s[t], Z[t]')
legend('show')
title('Zero Crossing Rate')
