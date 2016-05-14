clear all;
addpath('..');

dt = datestr(now,'dd_HH_MM');
mfilepath = fileparts(which(mfilename));
res_filename = strcat('./exp01_', dt, '.mat');
respath = fullfile(mfilepath, res_filename);

num_iterations = 10;
kernel_names = {'RBF_kernel', 'poly_kernel','lin_kernel'};

steps = 1;

outputs = [];
for Y_lags = 1:20
    for k =1:length(kernel_names)
        for iter = 1:num_iterations
          [Xtrain, Ytrain, Xval, Yval, Xtest, Ytest] = ...
              get_data(0, Y_lags, false);
          result  = ls_learner( Xtrain, Ytrain, Xval, Yval, ...
               Y_lags, steps, kernel_names{k});
           output.steps = steps;
           output.lags = Y_lags;
           output.kernel = kernel_names{k};
           output.iteration = iter;
           output.mse = result.errors.mse;
           output.mae = result.errors.mae;
           output.mape = result.errors.mape;
           output.details = result;
           outputs = [outputs output];
           save(respath, 'outputs');
        end
    end
end

rmpath('..');