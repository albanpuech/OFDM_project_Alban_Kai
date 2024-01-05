clear variables;
close all;
clc;
clear all;
addpath ./src
n_experiments = 20;

pilot_range = 1:10;
data_block_len = length(pilot_range);

conf = conf_pilot(1);

ber_list_viterbi = zeros(data_block_len,1);
ber_list_block = zeros(data_block_len,1);
for i=1:data_block_len
    ber = zeros(n_experiments,1);
    ber_block = zeros(n_experiments,1);
    for j=1:n_experiments
        conf = conf_pilot(i);
        if (i==1 && j==1) || ((i==data_block_len && j==1))
            conf.plot = 1;
        end
        res = run_sim(conf);
        ber(j) = res.ber;

        conf.phase_tracking_alg = 0;
        res = run_sim(conf);
        ber_block(j) = res.ber;

    end
    ber_list_viterbi(i) = mean(ber)
    ber_list_block(i) = mean(ber_block)
end

figure('Name', 'BER vs Pilot Interval');
plot(pilot_range, log(ber_list_viterbi), '-', 'LineWidth', 2); % Increase line width to 2
hold on
plot(pilot_range, log(ber_list_block), '-', 'LineWidth', 2);
legend('Viterbi and Block', 'Block only'); % Corrected legend command


% Add labels with LaTeX interpreter
xlabel('Pilot Interval', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('${\log(BER)}$', 'Interpreter', 'latex', 'FontSize', 12); % Using LaTeX for Y-label

% Add title
title('BER vs Pilot Interval', 'Interpreter', 'latex', 'FontSize', 16);