clear all;
clc;
load ('exp10_fw_25_23_17.mat');

addpath('..');
gam = 10.065643407999957;
sig2 = [];
Xlags = 1;
Ylags = 10;
steps = 3;

[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( Xlags, Ylags, true );
Xtrain = Xtrain(:, inmodel);
Xtest = Xtest(:, inmodel);
result = tester(Xtrain, Ytrain, Xtest, Ytest, ...
    Ylags, steps, gam, sig2);

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

save('best_fw.mat', 'result');
fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);