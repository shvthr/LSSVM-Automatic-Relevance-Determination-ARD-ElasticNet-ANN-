clc;
clear all;
data = csvread('..\data_nodate.csv');
X = data(:, 1:end-1);
Y = data(:, end);
num_features = size(X, 2);
lags = 20;

correlations = zeros(lags, 1);
for i=1:lags
    crr = corrcoef(Y(1:end-i), Y(i+1:end));
    correlations(i, 1) = crr(1,2);
end

figure;
hold on;
bar(correlations);
set(gca, 'XTick', 1:lags);
set(gca, 'XTickLabelRotation', 90);
title ('auto-correlations');
xlabel('lags');
ylabel('correlation coefficient');