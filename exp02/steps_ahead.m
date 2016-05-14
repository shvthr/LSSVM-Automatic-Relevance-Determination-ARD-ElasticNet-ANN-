clear all;
clc;
load ('exp02_10_23_22.mat');


min_mse = inf;
best_ind = -1;
for i=1:size(outputs,2)
    if outputs(i).mse < min_mse
        min_mse = outputs(i).mse;
        best_ind = i;
    end
end

fprintf('Ylags:\t%d\n', outputs(best_ind).lags);
fprintf('kernel:\t%s\n', outputs(best_ind).kernel);
fprintf('mse:\t%f\n', outputs(best_ind).mse);
fprintf('mae:\t%f\n', outputs(best_ind).mae);
fprintf('mape:\t%f\n', outputs(best_ind).mape);

steps = 12;
addpath('..');
model = outputs(best_ind).details.model;
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( 0, outputs(best_ind).lags, false );
result = tester(Xtest, Ytest, outputs(best_ind).lags, steps, model);

step_pred = zeros(12,1);
for i=1:12
    step_pred(i) = result.predictions(i,i);
end
figure;
hax = axes;
hold on;
SP = length(Yval);
for i=1:12
    line([SP+i SP+i], [Ytest(i) step_pred(i)], ...
        'LineWidth', 0.25, ...
        'Color', [0.5 0.5 0.5], ...
        'LineStyle', ':');
end
plot([Yval; Ytest(1:12)], 'g.-','MarkerSize', 10);
plot(SP+1:SP+12, step_pred, 'r.-', 'MarkerSize', 10);
xlabel('time');
ylabel('BEL20 index');

line([SP+1 SP+1],get(hax,'YLim'),'Color','blue')
rmpath('..');