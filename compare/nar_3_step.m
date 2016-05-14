load ('..\exp02\exp02_24_22_03.mat');
steps = 3;

min_mse = inf;
best_ind = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < min_mse
        min_mse = outputs(i).mse;
        best_ind = i;
    end
end

addpath('..');
model = outputs(best_ind).details.model;
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( 0, outputs(best_ind).lags, false );
addpath('..\exp02');
result = tester(Xtest, Ytest, outputs(best_ind).lags, steps, model);
rmpath('..\exp02');
rmpath('..');

load ('..\exp04\best_net.mat');
sz = length(actuals);
ls_pred_all = result.predictions(end-sz+1:end, :);
actuals_all = actuals;
predictions_all = predictions;

names = {'first step', 'second step', 'third step'};

for i=1:3
    actuals = actuals_all(i:sz+i-steps);
    predictions = predictions_all(i:sz+i-steps, i);
    ls_pred = ls_pred_all(i:sz+i-steps, i);
    figure;
    hold on;
    for j=1:sz-steps+1
        line([j j], [ls_pred(j) actuals(j)], ...
            'LineStyle', ':', ...
            'Color', [0.5 0.5 0.5] );
        line([j j], [predictions(j) actuals(j)], ...
            'LineStyle', ':', ...
            'Color', [0.5 0.5 0.5]);
    end
    l1 = plot(actuals, 'g.-', ...
        'MarkerSize', 20, ...
        'LineWidth', 1.5);
    l2 = plot(predictions, '.-', ...
        'MarkerSize', 20, ...
        'LineWidth', 1.5);
    l3 = plot(ls_pred, '.-', ...
        'MarkerSize', 20, ...
        'LineWidth', 1.5);
    legend([l1 l2 l3], 'actuals', 'ANN', 'LSSVM');
   % title(names{i});
   xlabel('Time');
ylabel('BEL20 Stock Index');
end