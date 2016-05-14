clc;
clear all;
data = csvread('..\data_nodate.csv');
X = data(:, 1:end-1);
Y = data(:, end);
num_features = size(X, 2);
figure;
for lags = 1:3
    correlations = zeros(num_features, 1);
for i=1:num_features
    crr = corrcoef(X((1:end-lags), i), Y(lags+1:end));
    correlations(i, 1) = crr(1,2);
end
subplot(3, 1, lags);
bar(correlations);
set(gca, 'XTick', 1:num_features);
set(gca, 'XTickLabelRotation', 90);
title (['lags = ', num2str(lags)]);
xlabel('exogenous features');
ylabel('correlation coefficient');
end