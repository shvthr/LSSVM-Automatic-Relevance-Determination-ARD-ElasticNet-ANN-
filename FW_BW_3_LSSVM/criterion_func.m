function [ criterion ] = criterion_func( X, Y )

Xtrain = X(1:220, :);
Ytrain = Y(1:220, :);
Xtest = X(221:end, :);
Ytest = Y(221:end, :);

% values set based on the previous experiments 
steps = 3;
Y_lags = 10;
gam = 10.065643407999957;
sig2 = [];
kernel_name = 'lin_kernel';

mfilepath = fileparts(which(mfilename));
libpath = fullfile(mfilepath,'../../lssvmlab');
addpath(libpath);

model = initlssvm(Xtrain, Ytrain, 'function estimation', ...
    [], [], kernel_name, 'preprocess');

model = changelssvm(model, 'gam', gam);
%model = changelssvm(model, 'kernel_pars', sig2);
model = trainlssvm (model);

num_days = size(Xtest, 1); 
predictions = nan(num_days, steps);

for i = 1:num_days - steps + 1
    current_row = Xtest(i, :);
    for j = 1:steps
        current_prediction = simlssvm(model, current_row);
        predictions(i+j-1,j) = current_prediction;
        current_row(1, end-Y_lags+1:end-1) = ...
            current_row(1, end-Y_lags+2:end);
        if Y_lags > 0
            current_row(1, end) = current_prediction;
        end
    end
end

rmpath(libpath);

result.gam = gam;
result.sig2 = sig2;
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


