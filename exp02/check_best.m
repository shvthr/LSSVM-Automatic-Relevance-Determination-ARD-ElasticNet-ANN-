clear all;
clc;
load ('exp02_10_23_22.mat');

steps = 3;

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
result = tester(Xtest, Ytest, outputs(best_ind).lags, steps, model);
sz = size(result.actuals, 1);
names = {'first step', ...
    'second step', ...
    'third step'};
for i =1:3
    plot_2lines(result.actuals(i:sz-steps+i), ...
        result.predictions(i:sz-steps+i, i));
    title(names{i});
end
rmpath('..');

fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);