clear all;
clc;
load ('exp09_bw_25_23_20.mat');

addpath('..');
gam = 2.630857185974892e+05;
sig2 = 6.557221533110840e+04;
Xlags = 2;
Ylags = 10;
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( Xlags, Ylags, true );
Xtrain = Xtrain(:, inmodel);
Xtest = Xtest(:, inmodel);
result = tester(Xtrain, Ytrain, Xtest, Ytest, ...
    Ylags, 1, gam, sig2);
plot_2lines(result.actuals, result.predictions);
rmpath('..');

save('best_bw.mat', 'result');
fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);