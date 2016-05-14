clear all;
clc;
load ('exp07_25_14_28.mat');


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

Y_lags = outputs(best_ind).Ylags;
X_lags = outputs(best_ind).Xlags;
num_hidden = outputs(best_ind).num_hidden;
fprintf('Xlags:\t%d\n', outputs(best_ind).Xlags);
fprintf('Ylags:\t%d\n', outputs(best_ind).Ylags);
fprintf('hidden neurons:\t%d\n', outputs(best_ind).num_hidden);
fprintf('train function:\t%s\n', outputs(best_ind).train_fcn);
fprintf('transfer function:\t%s\n', outputs(best_ind).transfer_fcn);


addpath('..');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( X_lags, Y_lags, false );
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