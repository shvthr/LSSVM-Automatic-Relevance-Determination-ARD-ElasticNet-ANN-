clear all;
addpath('..');

dt = datestr(now,'dd_HH_MM');
mfilepath = fileparts(which(mfilename));
res_filename = strcat('./exp04_', dt, '.mat');
respath = fullfile(mfilepath, res_filename);

num_iterations = 10;

trans_funcs = {'tansig'};
% trans_funcs = {'radbas', 'logsig', 'tansig'};

train_funcs = {'trainrp'};
% train_funcs = {'trainlm', 'trainrp', 'traingdx'};

steps = 3;

outputs = [];
for Y_lags = 1:20
    for num_hidden = [5, 10, 20]
        for trans_id =1:length(trans_funcs)
            for train_id = 1:length(train_funcs)
                for iter = 1:num_iterations
                    [Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
                        get_data(0, Y_lags, false);
                    result = ann_learner( Xtrain, Ytrain, Xval, Yval, ...
                        Y_lags, steps, num_hidden, ...
                        trans_funcs{trans_id}, train_funcs{train_id});
                    output.steps = steps;
                    output.lags = Y_lags;
                    output.iteration = iter;
                    output.num_hidden = num_hidden;
                    output.transfer_fcn = trans_funcs{trans_id};
                    output.train_fcn = train_funcs{train_id};
                    output.mse = result.errors.mse;
                    output.mae = result.errors.mae;
                    output.mape = result.errors.mape;
                    output.details = result;
                    outputs = [outputs output];
                    save(respath, 'outputs');
                end
            end
        end
    end
end

rmpath('..');