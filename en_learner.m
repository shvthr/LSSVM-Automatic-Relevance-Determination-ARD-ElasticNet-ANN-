function [ result ] = en_learner( Xtrain, Ytrain, Xtest, Ytest, ...
    Y_lags, steps, alpha)


opts = statset('UseParallel',true);
[b, fitinfo] = lasso(Xtrain, Ytrain,'CV',10, ...
    'Alpha', alpha, 'Options',opts);
rhat = b(: , fitinfo.IndexMinMSE);

num_days = size(Xtest, 1); 
predictions = nan(num_days, steps);

for i = 1:num_days - steps + 1
    current_row = Xtest(i, :);
    for j = 1:steps
        current_prediction = current_row * rhat;
        predictions(i+j-1,j) = current_prediction;
        current_row(1, end-Y_lags+1:end-1) = ...
            current_row(1, end-Y_lags+2:end);
        if Y_lags > 0
            current_row(1, end) = current_prediction;
        end
    end
end

result.b = b;
result.fitinfo = fitinfo;
result.actuals = Ytest;
result.predictions = predictions;

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

errors.mse = mse(actuals_list - predictions_list);
errors.mae = mae(actuals_list - predictions_list);
errors.mape = mean(abs(actuals_list - predictions_list) ./ actuals_list);

result.errors = errors;

end

