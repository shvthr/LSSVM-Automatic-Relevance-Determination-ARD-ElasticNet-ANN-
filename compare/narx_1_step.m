load ('..\exp05\exp05_24_23_52.mat');

min_mse = inf;
best_ind = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < min_mse
        min_mse = outputs(i).mse;
        best_ind = i;
    end
end

addpath('..');
gam = outputs(best_ind).details.gam;
sig2 = outputs(best_ind).details.sig2;
Xlags = outputs(best_ind).Xlags;
Ylags = outputs(best_ind).Ylags;
addpath('..\exp05');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( Xlags, Ylags, false );
result = tester(Xtrain, Ytrain, Xtest, Ytest, ...
    Ylags, 1, gam, sig2);
rmpath('..\exp05');
rmpath('..');

load ('..\exp07\best_net.mat');
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