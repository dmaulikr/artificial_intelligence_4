function p=gaussian_pdf(x, m, s)
%
% Calculates the Gaussian probability of x given the mean 
% and variance.
%
% params:
%
% x: the value whose probability is needed
% m: the Gaussian's mean
% s: the Gaussian's standard deviation

p=1/(sqrt(2 * pi * (s^2))) * exp(-((x - m)^2) / (2 * (s^2)));