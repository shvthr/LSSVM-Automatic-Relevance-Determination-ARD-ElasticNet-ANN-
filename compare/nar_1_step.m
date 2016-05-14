load ('..\exp01\exp01_24_21_49.mat');

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
addpath('..\exp01');
result = tester(Xtest, Ytest, outputs(best_ind).lags, 1, model);
rmpath('..\exp01');
rmpath('..');

load ('..\exp03\best_net.mat');
sz = length(actuals);
ls_pred = result.predictions(end-sz+1:end);
figure;
hold on;
for i=1:sz
    line([i i], [ls_pred(i) actuals(i)], ...
        'LineStyle', ':', ...
        'Color', [0.5 0.5 0.5] );
    line([i i], [predictions(i) actuals(i)], ...
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
xlabel('Time');
ylabel('BEL20 Stock Index');