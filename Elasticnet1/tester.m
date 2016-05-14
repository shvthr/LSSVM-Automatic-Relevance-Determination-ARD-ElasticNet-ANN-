clear all;
X_lags = 3;
Y_lags = 20;
steps = 1;
alpha = 0.25;
iter = 1;

addpath('..');
[Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
    get_data(X_lags, Y_lags, true);
result  = en_learner( Xtrain, Ytrain, Xval, Yval, ...
    Y_lags, steps, alpha);
output.steps = steps;
output.Xlags = X_lags;
output.Ylags = Y_lags;
output.alpha = alpha;
output.iteration = iter;
output.mse = result.errors.mse;
output.mae = result.errors.mae;
output.mape = result.errors.mape;
output.details = result;
rmpath('..');
