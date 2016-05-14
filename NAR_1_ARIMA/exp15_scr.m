clear all;

dt = datestr(now,'dd_HH_MM');
mfilepath = fileparts(which(mfilename));
res_filename = strcat('./exp15_', dt, '.mat');
respath = fullfile(mfilepath, res_filename);

vals = cell(1, 50);
outputs = cell(1, 50);

cnt = 1;
for p = 3:7
    for q = 3:7
        for d = [0 1]
            vals{cnt} = [p,q,d];
            cnt = cnt + 1;
        end
    end
end

parfor i = 1 : 50
    p = vals{i}(1);
    q = vals{i}(2);
    d = vals{i}(3);
    fprintf('p:%d q:%d d:%d\n', p, q, d);
    result  = arima_learner(p, q, d);
    outputs{i}.p = p;
    outputs{i}.q = q;
    outputs{i}.d = d;
    outputs{i}.mse = result.errors.mse;
    outputs{i}.mae = result.errors.mae;
    outputs{i}.mape = result.errors.mape;
    outputs{i}.actuals = result.actuals;
    outputs{i}.predictions = result.predictions;
end

save(respath, 'outputs');