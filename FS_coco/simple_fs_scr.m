clear all;

dt = datestr(now,'dd_HH_MM');
mfilepath = fileparts(which(mfilename));
res_filename = strcat('./simple_fs_', dt, '.mat');
respath = fullfile(mfilepath, res_filename);

steps = 1;
X_lags = 3;
Y_lags = 20;
addpath('..');
[Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
    get_data(X_lags, Y_lags, false);
rmpath('..');

X = [Xtrain ; Xval];
Y = [Ytrain ; Yval];

C = corr(X);
mc = mean(abs(C));
figure;
hold on;
for i=1:size(mc, 2)
    h = bar(i, mc(1, i));
    if mc(1,i) > 0.45
        color = [89, 22.7, 5.1]/100;
    else
        color = [3.9, 67.5, 18]/100;
    end
    set(h, 'FaceColor', color);
end
hold off;

for i=1:3
    line([32*i+0.5, 32*i+0.5], [0, 0.6], ...
        'LineStyle', '--', ...
        'Color', [12.5, 12.5, 62.4]/100);
end
xlabel('Features')
ylabel('Coefficient')
selected = mc < 0.45;
Xtrain = Xtrain(:, selected);
Xtest = Xtest(:, selected);

addpath('..\..\lssvmlab');
model = initlssvm(Xtrain, Ytrain, 'function estimation', ...
    [], [], 'RBF_kernel', 'preprocess');
[gam,sig2] = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'mse'});
model = changelssvm(model, 'gam', gam);
model = changelssvm(model, 'kernel_pars', sig2);
model = trainlssvm (model);
Ypred = simlssvm(model, Xtest);
rmpath('..\..\lssvmlab');

addpath('..');
plot_2lines(Ytest, Ypred);
rmpath('..');
xlabel('Time')
ylabel('BEL20 index')
mserr = mse(Ytest - Ypred);
maerr = mae(Ytest - Ypred);
maperr = mean(abs(Ytest-Ypred) ./ Ytest);

fprintf('mse: %f\n', mserr);
fprintf('mae: %f\n', maerr);
fprintf('mape: %f\n', maperr);

