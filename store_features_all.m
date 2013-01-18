
% script for storing the features of all the files to
% .csv files

% working out the paths to the files
base_path = 'audio_files/';
silence_base_path = strcat(base_path, 'silence/silence_');
speech_base_path = strcat(base_path, 'speech/speech_');
filetype = '.dat';

sample_size = 50;

% silence

% the matrix containing E, M, ZCR for silence files
silence_M = zeros(sample_size, 3);

for i=1:sample_size
    % working out the paths to the files
    if i < 10
        silence_fn = strcat(silence_base_path, '0');
    else
        silence_fn = silence_base_path;
    end
    silence_fn = strcat(silence_fn, int2str(i), filetype);
    
    [ln_e, ln_m, avg_z] = calc_features(silence_fn, 0.3, 0.03);
    
    silence_M(i, :) = [ln_e, ln_m, avg_z];
end

% outputting the matrix to a file
csvwrite('silence_features.csv', silence_M);

% speech

% the matrix containing E, M, ZCR for speech files
speech_M = zeros(sample_size, 3);

for i=1:sample_size
    % working out the paths to the files
    if i < 10
        speech_fn = strcat(speech_base_path, '0');
    else
        speech_fn = speech_base_path;
    end
    speech_fn = strcat(speech_fn, int2str(i), filetype);
    
    [ln_e, ln_m, avg_z] = calc_features(speech_fn, 0.3, 0.03);
    
    speech_M(i, :) = [ln_e, ln_m, avg_z];
end

% outputting the matrix to a file
csvwrite('speech_features.csv', speech_M);