function [ ] = plot_2lines( actuals, predictions )

figure;
hold on;
for i=1:length(actuals)
    line([i i] , [predictions(i) actuals(i)], ...
        'LineWidth', 0.25, ...
        'Color', [0.5 0.5 0.5], ...
        'LineStyle', ':');
end
a_line = plot(actuals, 'g.-', 'LineWidth', 1.5, 'MarkerSize', 20);
p_line = plot(predictions, 'r.-', 'LineWidth', 1.5, 'MarkerSize', 20);
legend([a_line, p_line], 'actuals', 'predictions');
xlabel('time');
ylabel('BEL20 index');
hold off;

end

