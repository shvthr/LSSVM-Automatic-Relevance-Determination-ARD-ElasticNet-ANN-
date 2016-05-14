clear all;
mfilepath = fileparts(which(mfilename));
libpath = fullfile(mfilepath,'../../lssvmlab');
addpath(libpath);
addpath('..');

X_lags = 3;
Y_lags = 0;
[Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
        get_data(X_lags, Y_lags, true);

kernel_name = 'RBF_kernel';
model = initlssvm(Xtrain, Ytrain, 'function estimation', ...
    [], [], kernel_name, 'preprocess');
[gam,sig2] = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'mse'});
model = changelssvm(model, 'gam', gam);
model = changelssvm(model, 'kernel_pars', sig2);

[model, alpha, b] = bay_optimize(model, 1);
[model,gam] = bay_optimize(model, 2);
[model, sig2] = bay_optimize(model, 3);


[dimensions, ordered, costs, sig2s, model] = ...
    bay_lssvmARD(model, 'discrete', 'eigs', 10);


% model = trainlssvm (model);

rmpath('..');
rmpath(libpath);