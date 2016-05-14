clear all;
clc;
load ('exp11_bw_25_23_19.mat');


train_fcn = 'trainrp';
transfer_fcn = 'tansig';
steps = 1;

Y_lags = 18;
X_lags = 1;
num_hidden = 5;

addpath('..');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( X_lags, Y_lags, true );
Xtrain = Xtrain(:, inmodel);
Xtest = Xtest(:, inmodel);
[result, net]  = ann_learner( Xtrain, Ytrain, Xtest, Ytest, ...
    Y_lags, steps, num_hidden, transfer_fcn, train_fcn );
plot_2lines(result.actuals, result.predictions);
rmpath('..');

actuals = result.actuals;
predictions = result.predictions;
save('best_net_bw.mat', 'net', 'actuals', 'predictions');

fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);