clear all;
addpath('..');

dt = datestr(now,'dd_HH_MM');
mfilepath = fileparts(which(mfilename));
res_filename = strcat('./exp11_bw_', dt, '.mat');
respath = fullfile(mfilepath, res_filename);

X_lags = 1;
Y_lags = 18;

[Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
                    get_data(X_lags, Y_lags, true);

X = [Xtrain ; Xval];
Y = [Ytrain ; Yval];

Ylag_end = size(X, 2);
Ylag_start = Ylag_end - Y_lags + 1;
kept = [1:12 Ylag_start:Ylag_end];

sfsoptions.UseParallel = true;
[inmodel, history] = sequentialfs(@criterion_func, X, Y, ...
    'cv', 'none', ...
    'direction', 'backward', ...
    'keepin', kept, ...
    'options', sfsoptions);

save(respath, 'inmodel', 'history');


rmpath('..');