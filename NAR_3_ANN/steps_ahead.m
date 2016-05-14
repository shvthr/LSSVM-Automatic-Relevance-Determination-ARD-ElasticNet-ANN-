clear all;
clc;
%load ('exp04_25_14_28.mat');

lags = 18;
steps = 12;
addpath('..');
load('best_net');
[ Xtrain, Ytrain, Xval, Yval, Xtest, Ytest ] = ...
    get_data( 0, lags, false );
result = tester(Xtest, Ytest, lags, steps, net);

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
line([SP+1 SP+1],get(hax,'YLim'),'Color','blue');
xlabel('time');
ylabel('BEL20 index');
rmpath('..');