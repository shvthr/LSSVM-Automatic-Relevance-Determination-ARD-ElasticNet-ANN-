clear all;
clc;
load ('selected.mat');

addpath('..');
Xlags = 3;
Ylags = 20;
steps = 3;

[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( Xlags, Ylags, true );
Xtrain = [Xtrain(:, selected) Xtrain(:,end-Ylags+1:end)];
Xtest = [Xtest(:, selected) Xtest(:, end-Ylags+1:end)];
result = tester(Xtrain, Ytrain, Xtest, Ytest, ...
    Ylags, steps);

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

save('best.mat', 'result');
fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);