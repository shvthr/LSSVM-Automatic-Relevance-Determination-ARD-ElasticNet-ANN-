clear all;
clc;
load ('exp01_24_21_49.mat');

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


errors = zeros(20, 3, 3);
for lag = 1:20
    for k = 1:length(kernel_names)
        for i = 1:size(entries, 2)
            if entries(i).Ylags == lag && ...
                    strcmp(entries(i).kernel , kernel_names{k})
                errors(lag, k, 1) = entries(i).mse;
                errors(lag, k, 2) = entries(i).mae;
                errors(lag, k, 3) = entries(i).mape;
            end
        end
    end
end

kernel_str = {'RBF', 'Poly', 'Linear'};
error_names = {'mse', 'mae', 'mape'};
figure
k = 1;
for i=1:3
    for j=1:3
        subplot(3,3, k);
        plot(errors(:, i,j), ...
        '.-','LineWidth', 1.5, ...
        'MarkerSize', 10);
        title(kernel_str{i});
        xlabel('lags');
        ylabel(error_names{j});
        k = k+1;
    end
end
