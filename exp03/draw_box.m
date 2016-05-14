clear all;
clc;
load ('exp03_26_17_30.mat');

trans_func = 'tansig';
train_func = 'trainrp';
num_hidden = 5;
Ylags = 18;

best_mse = zeros(1, 10);
best_mae = zeros(1, 10);
best_mape = zeros(1,10);
j = 1;
for i = 1:size(outputs, 2)
    if outputs(i).lags == Ylags && ...
            outputs(i).num_hidden == num_hidden && ...
            strcmp(outputs(i).transfer_fcn, trans_func) && ...
            strcmp(outputs(i).train_fcn, train_func)
        best_mse(j) = outputs(i).mse;
        best_mae(j) = outputs(i).mae;
        best_mape(j) = outputs(i).mape;
        j = j + 1;
    end
end


figure;
subplot(1, 3, 1);
boxplot(best_mse, 'labels',{'mse'});
subplot(1, 3, 2);
boxplot(best_mae, 'labels',{'mae'});
subplot(1, 3, 3);
boxplot(best_mape, 'labels',{'mape'});

