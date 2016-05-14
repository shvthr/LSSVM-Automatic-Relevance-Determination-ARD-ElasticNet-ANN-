clc;
clear all;
data = csvread('..\data_nodate.csv');
X = data(:, 1:end-1);
Y = data(:, end);

s_start = size(Y, 1) - 33;
s_end = size(Y,1);

actuals = Y(s_start:s_end);
predictions = Y(s_start-1:s_end-1);
mse = mse(actuals - predictions);
mae = mae(actuals - predictions);
mape = mean(abs((actuals - predictions) ./ actuals));
addpath('..');
plot_2lines(actuals, predictions);
rmpath('..');

fprintf('mse: %f\n', mse);
fprintf('mae: %f\n', mae);
fprintf('mape: %f\n', mape);

