clear all;
clc;
load ('exp05_24_23_52.mat');

min_mse = inf;
best_ind = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < min_mse
        min_mse = outputs(i).mse;
        best_ind = i;
    end
end




addpath('..');
gam = outputs(best_ind).details.gam;
sig2 = outputs(best_ind).details.sig2;
Xlags = outputs(best_ind).Xlags;
Ylags = outputs(best_ind).Ylags;
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( Xlags, Ylags, false );
result = tester(Xtrain, Ytrain, Xtest, Ytest, ...
    Ylags, 1, gam, sig2);
plot_2lines(result.actuals, result.predictions);
rmpath('..');

fprintf('Xlags:\t%d\n', outputs(best_ind).Xlags);
fprintf('Ylags:\t%d\n', outputs(best_ind).Ylags);
fprintf('kernel:\t%s\n', outputs(best_ind).kernel);
fprintf('mse:\t%f\n', result.errors.mse);
fprintf('mae:\t%f\n', result.errors.mae);
fprintf('mape:\t%f\n', result.errors.mape);