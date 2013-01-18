function k_fold(K)
%
% function which performs a K-fold validation over the values
% in 'speech_features.csv' and 'silence_features.csv'
%
% params:
%
% K: the K value

% sample size for each class
SAMPLE_SIZE = 50; 

% the size
subset_size = double(SAMPLE_SIZE / K);

speech_M = csvread('speech_features.csv');
silence_M = csvread('silence_features.csv');

total_errors=0;

accuracy = [];

for i=1:K
    fprintf('Iteration %d\n\n', i);
    
    test_indices = (K - i) * subset_size + 1:(K - i + 1) * subset_size;
    fprintf('test_indices\n');
    disp(test_indices);
    
    % the train indices will be the difference between the 
    % whole set of indices and the test indices
    train_indices = setdiff(1:SAMPLE_SIZE, test_indices);
    fprintf('train_indices\n');
    disp(train_indices);
    
    % getting m and s for E, M, ZCR, for speech and silence 
    % train indices
    
    [speech_E_m, speech_E_s] = get_mean_variance('speech', ...
        1, train_indices);
    [speech_M_m, speech_M_s] = get_mean_variance('speech', ...
        2, train_indices);
    [speech_Z_m, speech_Z_s] = get_mean_variance('speech', ...
        3, train_indices);
    
    [silence_E_m, silence_E_s] = get_mean_variance('silence', ...
        1, train_indices);
    [silence_M_m, silence_M_s] = get_mean_variance('silence', ...
        2, train_indices);
    [silence_Z_m, silence_Z_s] = get_mean_variance('silence', ...
        3, train_indices);
    
    fprintf('speech training:\nE: m:%f s:%f\nM: m:%f s:%f\nZ: m:%f s:%f\n\n', ...
            speech_E_m, speech_E_s, speech_M_m, speech_M_s, speech_Z_m, ...
            speech_Z_s)
        
    fprintf('silence training:\nE: m:%f s:%f\nM: m:%f s:%f\nZ: m:%f s:%f\n\n', ...
            silence_E_m, silence_E_s, silence_M_m, silence_M_s, ...
            silence_Z_m, silence_Z_s);
  
    errors = 0;
    
    % first, the speech samples are tested
    for j=1:subset_size
        index = test_indices(j);
        
        ln_E = speech_M(index, 1);
        ln_M = speech_M(index, 2);
        avg_Z = speech_M(index, 3);
        fprintf('Speech test sample %d: E: %f, M:%f, Z:%f. ', ...
            index, ln_E, ln_M, avg_Z);
        
        p_E_given_C_speech = gaussian_pdf(ln_E, speech_E_m, ...
            speech_E_s);
        p_M_given_C_speech = gaussian_pdf(ln_M, speech_M_m, ...
            speech_M_s);
        p_Z_given_C_speech = gaussian_pdf(avg_Z, speech_Z_m, ...
            speech_Z_s);
        
        p_E_given_C_silence = gaussian_pdf(ln_E, silence_E_m, ...
            silence_E_s);
        p_M_given_C_silence = gaussian_pdf(ln_M, silence_M_m, ...
            silence_M_s);
        p_Z_given_C_silence = gaussian_pdf(avg_Z, silence_Z_m, ...
            silence_Z_s);
        
        % P(C=speech) and P(C=silence) are unnecessary since both are 0.5
        C_speech_product = p_E_given_C_speech * ...
            p_M_given_C_speech * p_Z_given_C_speech;
        C_silence_product = p_E_given_C_silence * ...
            p_M_given_C_silence * p_Z_given_C_silence;        
        
        if C_speech_product <= C_silence_product
            fprintf('Error, sample predicted to be silence\n');
            errors = errors + 1;
            total_errors = total_errors + 1;
        else
            fprintf('Successful prediction\n');
        end
    end
        
    % afterwards, the silence samples are tested
    for j=1:subset_size
        index = test_indices(j);
        
        ln_E = silence_M(index, 1);
        ln_M = silence_M(index, 2);
        avg_Z = silence_M(index, 3);
        fprintf('Silence test sample %d: E: %f, M:%f, Z:%f. ', ...
            index, ln_E, ln_M, avg_Z);
        
        p_E_given_C_speech = gaussian_pdf(ln_E, speech_E_m, ...
            speech_E_s);
        p_M_given_C_speech = gaussian_pdf(ln_M, speech_M_m, ...
            speech_M_s);
        p_Z_given_C_speech = gaussian_pdf(avg_Z, speech_Z_m, ...
            speech_Z_s);
        
        p_E_given_C_silence = gaussian_pdf(ln_E, silence_E_m, ...
            silence_E_s);
        p_M_given_C_silence = gaussian_pdf(ln_M, silence_M_m, ...
            silence_M_s);
        p_Z_given_C_silence = gaussian_pdf(avg_Z, silence_Z_m, ...
            silence_Z_s);
        
        % P(C=speech) and P(C=silence) are unnecessary since both are 0.5
        C_speech_product = p_E_given_C_speech * ...
            p_M_given_C_speech * p_Z_given_C_speech;
        C_silence_product = p_E_given_C_silence * ...
            p_M_given_C_silence * p_Z_given_C_silence;        
        
        if C_speech_product >= C_silence_product
            fprintf('Error, sample predicted to be speech\n');
            errors = errors + 1;
            total_errors = total_errors + 1;
        else
            fprintf('Successful prediction\n');
        end
        
    end
    fprintf('Errors: %d\nAccuracy %d%%\n\n\n', errors, ...
        (1-(errors/(2 *subset_size))) * 100);
    
    accuracy(i) = (1-(errors/(2 *subset_size))) * 100;
end

fprintf('Total errors %d\n', total_errors);
fprintf('Total accuracy %d%%\n', mean(accuracy));