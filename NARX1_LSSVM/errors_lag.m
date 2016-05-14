clear all;
clc;
load ('exp05_24_23_52.mat');

kernel_names = {'RBF_kernel', 'poly_kernel','lin_kernel'};

steps = 1;

entries = [];
for Y_lags = 1:20
    for X_lags = 1:3
        for k =1:length(kernel_names)
            current_entry.Ylags = Y_lags;
            current_entry.Xlags = X_lags;
            current_entry.kernel = kernel_names{k};
            sse = 0;
            mae = 0;
            mape = 0;
            for i = 1:size(outputs, 2)
                if outputs(i).Ylags == Y_lags && ...
                        outputs(i).Xlags == X_lags && ...
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
end
    
    
errors = zeros(20, 3, 3, 3);
for Ylag = 1:20
    for Xlag = 1:3
        for k = 1:length(kernel_names)
            for i = 1:size(entries, 2)
                if entries(i).Ylags == Ylag && ...
                        entries(i).Xlags == Xlag && ...
                        strcmp(entries(i).kernel , kernel_names{k})
                    errors(Ylag, Xlag, k, 1) = entries(i).mse;
                    errors(Ylag, Xlag, k, 2) = entries(i).mae;
                    errors(Ylag, Xlag, k, 3) = entries(i).mape;
                end
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
        mesh(errors(:, :, i,j));
        view(180+45, 20);
        title(kernel_str{i});
        xlabel('Xlags');
        ylabel('Ylags');
        zlabel(error_names{j});
        k = k+1;
    end
end
