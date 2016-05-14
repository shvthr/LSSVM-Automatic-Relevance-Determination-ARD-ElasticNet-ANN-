clear all;
clc;
load ('exp01_10_23_21.mat');

min_mse = inf;
best_ind = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < min_mse
        min_mse = outputs(i).mse;
        best_ind = i;
    end
end

fprintf('Ylags:\t%d\n', outputs(best_ind).lags);
fprintf('kernel:\t%s\n', outputs(best_ind).kernel);


addpath('..');
model = outputs(best_ind).details.model;
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( 0, outputs(best_ind).lags, false );
result = tester(Xtest, Ytest, outputs(best_ind).lags, 1, model);
plot_2lines(result.actuals, result.predictions);
rmpath('..');

fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);