clear all;
addpath('..');

dt = datestr(now,'dd_HH_MM');
mfilepath = fileparts(which(mfilename));
res_filename = strcat('./exp14_', dt, '.mat');
respath = fullfile(mfilepath, res_filename);

steps = 3;

outputs = [];
X_lags = 3;
Y_lags = 20;

for alpha = 0.25:0.25:1
    [Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
        get_data(X_lags, Y_lags, true);
    result  = en_learner( Xtrain, Ytrain, Xval, Yval, ...
        Y_lags, steps, alpha);
    output.steps = steps;
    output.Xlags = X_lags;
    output.Ylags = Y_lags;
    output.alpha = alpha;
    output.mse = result.errors.mse;
    output.mae = result.errors.mae;
    output.mape = result.errors.mape;
    output.details = result;
    outputs = [outputs output];
    save(respath, 'outputs');
end

rmpath('..');