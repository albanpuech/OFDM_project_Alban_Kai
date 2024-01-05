clear variables;
close all;
clc;
clear all;
addpath ./src

n_experiments = 10;
SNR_min = 0;
SNR_max = 30;
nb_snr_values = 20;
SNR_range = linspace(SNR_min,SNR_max,nb_snr_values);

conf = conf_snr();

ber_list = zeros(nb_snr_values,1);
for i=1:nb_snr_values
    ber = zeros(n_experiments,1);
    SNR_range(i);
    for j=1:n_experiments
        conf.SNR = SNR_range(i);
        res = run_sim(conf);
        res.ber;
        ber(j) = res.ber;
    end
    ber_list(i) = log(median(ber))
end

figure();
plot(SNR_range,ber_list)
