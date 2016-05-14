function [result] = arima_learner(p, q, d)

mfilepath = fileparts(which(mfilename));
datapath = fullfile(mfilepath, '../data_nodate.csv');

data = csvread(datapath);
Y = data(:, end);
train_size = 220;
val_size = 30;

model = arima(p,d,q);
model = estimate(model,Y(1:train_size));

Ypred = zeros(val_size, 1);
for i=1:val_size
    [Ypred(i) YMSE] = forecast(model,1,'Y0',Y(i:i+train_size));
end

Yval = Y(train_size+1:train_size+val_size);

result.p = p;
result.q = q;
result.d = d;

result.actuals = Yval;
result.predictions = Ypred;

errors.mse = mse(Yval - Ypred);
errors.mae = mae(Yval - Ypred);
errors.mape = mean(abs(Yval - Ypred) ./ Yval);
result.errors = errors;

end