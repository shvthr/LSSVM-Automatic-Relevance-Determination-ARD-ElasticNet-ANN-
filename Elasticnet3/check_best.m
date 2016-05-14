clear all;
load('exp14_09_02_46.mat');

X_lags = 3;
Y_lags = 20;
steps = 3;

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


addpath('..');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( X_lags, Y_lags, true );


num_days = size(Xtest, 1); 
predictions = nan(num_days, steps);

for i = 1:num_days - steps + 1
    current_row = Xtest(i, :);
    for j = 1:steps
        current_prediction = current_row * b + c;
        predictions(i+j-1,j) = current_prediction;
        current_row(1, end-Y_lags+1:end-1) = ...
            current_row(1, end-Y_lags+2:end);
        if Y_lags > 0
            current_row(1, end) = current_prediction;
        end
    end
end

actuals = Ytest;
sz = size(actuals, 1);
names = {'first step', ...
    'second step', ...
    'third step'};
for i =1:3
    plot_2lines(actuals(i:sz-steps+i), ...
        predictions(i:sz-steps+i, i));
    title(names{i});
    xlabel('Time')
    ylabel('BEL20 index')
end
rmpath('..');


actuals_list = [];
predictions_list = [];
for i=1:num_days
    for j=1:steps
        if ~isnan(predictions(i,j))
            actuals_list = [actuals_list Ytest(i, 1)];
            predictions_list = [predictions_list predictions(i,j)];
        end
    end
end

mserror = mse(actuals_list - predictions_list);
maerror = mae(actuals_list - predictions_list);
maperror = mean(abs(actuals_list - predictions_list) ./ actuals_list);

fprintf('alpha:\t%f\n', alpha);
fprintf('mse:\t%f\n', mserror);
fprintf('mae:\t%f\n', maerror);
fprintf('mape:\t%f\n', maperror);
