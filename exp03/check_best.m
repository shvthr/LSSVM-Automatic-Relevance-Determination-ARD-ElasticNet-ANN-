clear all;
clc;
load ('exp03_10_23_22.mat');

Y_lags = 18;
num_hidden = 5;
train_fcn = 'trainrp';
transfer_fcn = 'tansig';
steps = 1;

min_mse = inf;
best_ind = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < min_mse
        min_mse = outputs(i).mse;
        best_ind = i;
    end
end

fprintf('Ylags:\t%d\n', outputs(best_ind).lags);
fprintf('hidden neurons:\t%d\n', outputs(best_ind).num_hidden);
fprintf('train function:\t%s\n', outputs(best_ind).train_fcn);
fprintf('transfer function:\t%s\n', outputs(best_ind).transfer_fcn);


addpath('..');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( 0, Y_lags, false );
[result, net]  = ann_learner( Xtrain, Ytrain, Xtest, Ytest, ...
    Y_lags, steps, num_hidden, transfer_fcn, train_fcn );
plot_2lines(result.actuals, result.predictions);
rmpath('..');

actuals = result.actuals;
predictions = result.predictions;
save('best_net.mat', 'net', 'actuals', 'predictions');

fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);