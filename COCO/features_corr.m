clc;
clear all;
data = csvread('..\data_nodate.csv');
X = data(:, 1:end-1);
Y = data(:, end);
num_features = size(X, 2);
correlations = zeros(num_features, 1);
for i=1:num_features
    crr = corrcoef(X(:, i), Y);
    correlations(i, 1) = crr(1,2);
end
figure;
bar(correlations);
set(gca, 'XTick', 1:num_features);
set(gca, 'XTickLabelRotation', 90);
title ('correlations between features and target');
xlabel('exogenous features');
ylabel('correlation coefficient');