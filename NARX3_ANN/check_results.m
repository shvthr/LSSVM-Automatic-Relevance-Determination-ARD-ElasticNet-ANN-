clear all;
clc;
load ('exp08_25_14_28.mat');

kernel_names = {'RBF_kernel', 'poly_kernel','lin_kernel'};

steps = 3;

entries = [];
for X_lags = 1:3
    for Y_lags = 1:20
        for num_hidden = [5, 10, 20]
            current_entry.Xlags = X_lags;
            current_entry.Ylags = Y_lags;
            current_entry.num_hidden = num_hidden;
            sse = 0;
            mae = 0;
            mape = 0;
            for i = 1:size(outputs, 2)
                if outputs(i).Xlags == X_lags & ...
                        outputs(i).Ylags == Y_lags & ...
                        outputs(i).num_hidden == num_hidden
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
end

min_mse = inf;
best_ind = -1;
for i = 1 : size(entries, 2)
    if entries(i).mse < min_mse
        best_ind = i;
        min_mse = entries(i).mse;
    end
end

fprintf('Xlags:\t%d\n', entries(best_ind).Xlags);
fprintf('Ylags:\t%d\n', entries(best_ind).Ylags);
fprintf('hidden neurons:\t%d\n', entries(best_ind).num_hidden);
fprintf('mse:\t%f\n', entries(best_ind).mse);
fprintf('mae:\t%f\n', entries(best_ind).mae);
fprintf('mape:\t%f\n', entries(best_ind).mape);
