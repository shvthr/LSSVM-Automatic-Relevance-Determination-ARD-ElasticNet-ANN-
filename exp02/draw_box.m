clear all;
clc;
load ('exp02_24_22_03.mat');

kernel_names = {'RBF_kernel', 'poly_kernel','lin_kernel'};

steps = 1;

entries = [];
for Y_lags = 1:20
    for k =1:length(kernel_names)
        current_entry.Ylags = Y_lags;
        current_entry.kernel = kernel_names{k};
        sse = 0;
        mae = 0;
        mape = 0;
        for i = 1:size(outputs, 2)
            if outputs(i).lags == Y_lags && ...
                    strcmp(outputs(i).kernel, kernel_names{k})
                sse = sse + outputs(i).mse;
                mae = mae + outputs(i).mae;
                mape = mape + outputs(i).mape;
            end
        end
        current_entry.mse = sse/10;
        current_entry.mae = mae/10;
        current_entry.mape = mape/10;
        entries = [entries current_entry];
    end
end

min_mse = inf;
best_ind = -1;
for i = 1 : size(entries, 2)
    if entries(i).mse < min_mse
        best_ind = i;
        min_mse = entries(i).mse;
    end
end

best_entry = entries(best_ind);
best_mse = zeros(10, 1);
best_mae = zeros(10, 1);
best_mape = zeros(10, 1);
j = 1;
        for i = 1:size(outputs, 2)
            if outputs(i).lags == best_entry.Ylags && ...
                    strcmp(outputs(i).kernel, best_entry.kernel)
                best_mse(j) =  outputs(i).mse;
                best_mae(j) =  outputs(i).mae;
                best_mape(j) = outputs(i).mape;
                j = j+1;
            end
        end

figure;
subplot(1, 3, 1);
boxplot(best_mse, 'labels',{'mse'});
subplot(1, 3, 2);
boxplot(best_mae, 'labels',{'mae'});
subplot(1, 3, 3);
boxplot(best_mape, 'labels',{'mape'});

