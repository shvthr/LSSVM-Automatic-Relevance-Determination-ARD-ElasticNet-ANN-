function [ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( X_lags, Y_lags, use_calendar )

if nargin == 2
    use_calendar = false;
end

mfilepath = fileparts(which(mfilename));
datapath = fullfile(mfilepath, './data_nodate.csv');
calpath = fullfile(mfilepath, './calendar.csv');
libpath = fullfile(mfilepath,'../lssvmlab');

data = csvread(datapath);
X = data(:, 1:end-1);
Y = data(:, end);

addpath(libpath);
[Xw, Yw] = windowizeNARX(X, Y, X_lags, Y_lags);
rmpath(libpath);

xc = size(X, 2);
if X_lags > 0
    Xw = Xw(:, [1:xc*(X_lags-1) (xc*X_lags)+1:end]);
else
    Xw = Xw(:, xc+1:end);
end

if use_calendar
    cal_info = csvread(calpath);
    m = max(X_lags, Y_lags);
    cal_info = cal_info(m+1:end, :);
    Xw = [cal_info Xw];
end

Xtrain = Xw(1:220, :);
Ytrain = Yw(1:220, :);

Xval = Xw(221:250, :);
Yval = Yw(221:250, :);

Xtest = Xw(251:end, :);
Ytest = Yw(251:end, :);

end

