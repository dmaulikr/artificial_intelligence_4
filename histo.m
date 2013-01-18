
% draw the histograms of E, M and Z for silence and speech

silence_M = csvread('silence_features.csv');

% create new figure
figure;
hist(silence_M(:, 1));
title('silence - E');

% create new figure
figure;
hist(silence_M(:, 2));
title('silence - M');

% create new figure
figure;
hist(silence_M(:, 3));
title('silence - Z');

speech_M = csvread('speech_features.csv');

% create new figure
figure;
hist(speech_M(:, 1));
title('speech - E');

% create new figure
figure;
hist(speech_M(:, 2));
title('speech - M');

% create new figure
figure;
hist(speech_M(:, 3));
title('speech - Z');