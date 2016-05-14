clear all;
clc;
load ('exp03_09_00_52.mat');



steps = 1;
trans_funcs = {'radbas', 'logsig', 'tansig'};
train_funcs = {'trainlm', 'trainrp', 'traingdx'};
entries = [];
for Ylags = 1:20
    for num_hidden = [5, 10, 20]
        for trans_id =1:length(trans_funcs)
            for train_id = 1:length(train_funcs)
                current_entry.Ylags = Ylags;
                current_entry.num_hidden = num_hidden;
                current_entry.trans = trans_funcs{trans_id};
                current_entry.train = train_funcs{train_id};
                sse = 0;
                mae = 0;
                mape = 0;
                for i = 1:size(outputs, 2)
                    if outputs(i).lags == Ylags && ...
                            outputs(i).num_hidden == num_hidden && ...
                            strcmp(outputs(i).transfer_fcn, current_entry.trans) && ...
                            strcmp(outputs(i).train_fcn, current_entry.train)
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
end

min_mse = inf;
best_ind = -1;
for i = 1 : size(entries, 2)
    if entries(i).mse < min_mse
        best_ind = i;
        min_mse = entries(i).mse;
    end
end

fprintf('Ylags:\t%d\n', entries(best_ind).Ylags);
fprintf('num_hidden:\t%d\n', entries(best_ind).num_hidden);
fprintf('transfer function:\t%s\n', entries(best_ind).trans);
fprintf('train function:\t%s\n', entries(best_ind).train);
fprintf('mse:\t%f\n', entries(best_ind).mse);
fprintf('mae:\t%f\n', entries(best_ind).mae);
fprintf('mape:\t%f\n', entries(best_ind).mape);

