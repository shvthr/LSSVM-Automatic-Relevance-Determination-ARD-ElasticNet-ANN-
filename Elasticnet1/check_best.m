clear all;
load('exp13_09_02_46.mat');
best_mse = inf;
best_index = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < best_mse
        best_mse = outputs(i).mse;
        best_index = i;
    end
end

best_row = outputs(best_index);
alpha = best_row.alpha;
fitinfo = best_row.details.fitinfo;
indexMinMSE = fitinfo.IndexMinMSE;
b = best_row.details.b(:, indexMinMSE);
c = fitinfo.Intercept(indexMinMSE);

X_lags = 3;
Y_lags = 20;
addpath('..');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( X_lags, Y_lags, true );
Ypred = Xtest * b + c;
plot_2lines(Ytest, Ypred);
rmpath('..');
xlabel('Time')
ylabel('BEL20 index')
mserror = mse(Ytest-Ypred);
maerror = mae(Ytest-Ypred);
maperror = mean(abs((Ytest-Ypred)./Ytest));

fprintf('alpha:\t%f\n', alpha);
fprintf('mse:\t%f\n', mserror);
fprintf('mae:\t%f\n', maerror);
fprintf('mape:\t%f\n', maperror);