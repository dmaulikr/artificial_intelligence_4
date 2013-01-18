
% script for outputing the scatter plots of the features 
% E-M, E-Z and M-Z

silence_M = csvread('silence_features.csv');
speech_M = csvread('speech_features.csv');

% create new figure
figure;

plot(silence_M(:, 1), silence_M(:, 2), 'b.', 'DisplayName', 'silence'); 
hold on; % for continuing to plot at the same diagram
plot(speech_M(:, 1), speech_M(:, 2), 'r.', 'DisplayName', 'speech'); 
hold off;
xlabel('E');
ylabel('M');
legend('show', 'Location', 'NorthWest')
title('E - M');

% create new figure
figure;

plot(silence_M(:, 1), silence_M(:, 3), 'b.', 'DisplayName', 'silence'); 
hold on; % for continuing to plot at the same diagram
plot(speech_M(:, 1), speech_M(:, 3), 'r.', 'DisplayName', 'speech'); 
hold off;
xlabel('E');
ylabel('Z');
legend('show')
title('E - Z');

% create new figure
figure;

plot(silence_M(:, 2), silence_M(:, 3), 'b.', 'DisplayName', 'silence'); 
hold on; % for continuing to plot at the same diagram
plot(speech_M(:, 2), speech_M(:, 3), 'r.', 'DisplayName', 'speech'); 
hold off;
xlabel('M');
ylabel('Z');
legend('show')
title('M - Z');