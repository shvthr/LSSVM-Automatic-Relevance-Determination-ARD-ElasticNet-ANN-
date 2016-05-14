function [ criterion ] = criterion_func( X, Y )

Xtrain = X(1:220, :);
Ytrain = Y(1:220, :);
Xtest = X(221:end, :);
Ytest = Y(221:end, :);

% parameters set based on previous experiments
steps = 3;
Y_lags = 18;
num_hidden = 5;
transfer_fcn = 'tansig';
train_fcn = 'trainrp';

Xtrain = Xtrain';
Ytrain = Ytrain';

net = feedforwardnet(num_hidden);

net.divideFcn = 'dividerand';
net.divideParam.testRatio = 0;
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.2;

net = configure(net, Xtrain , Ytrain);
net.layers{1,1}.transferFcn = transfer_fcn;
net.layers{2,1}.transferFcn = transfer_fcn;
net.trainFcn = train_fcn;
net.trainParam.showWindow = false;

net = train(net , Xtrain , Ytrain);

num_days = size(Xtest, 1); 
predictions = nan(num_days, steps);

for i = 1:num_days - steps + 1
    current_row = Xtest(i, :);
    for j = 1:steps
        current_prediction = sim(net, current_row');
        predictions(i+j-1,j) = current_prediction;
        current_row(1, end-Y_lags+1:end-1) = ...
            current_row(1, end-Y_lags+2:end);
        if Y_lags > 0
            current_row(1, end) = current_prediction;
        end
    end
end

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

% returning sum of squared errors 
% 'sequentialfs' will divide by #cases 
criterion = sse(actuals_list - predictions_list);

end


