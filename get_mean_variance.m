function [m,s]=get_mean_variance(type, feature, indices)
%
% Returns the mean and variance of a feature for a
% specific type and indices.
%
% params:
%
% type: 'speech' or 'silence'
% feature: 1, 2 or 3 for Energy, Magnitude and ZCR respectively
% indices: the set of indices to use to extract m and s
%

if strcmp(type, 'speech')
    M = csvread('speech_features.csv');
elseif strcmp(type, 'silence')
    M = csvread('silence_features.csv');
end

feature_M = M(indices, feature);

feature_sum = sum(feature_M);

m = feature_sum / size(feature_M, 1);

squared_error = 0;

for i=1:size(feature_M, 1)
    squared_error = squared_error + ((feature_M(i) - m)^2);
end

s=sqrt(squared_error / size(feature_M, 1));