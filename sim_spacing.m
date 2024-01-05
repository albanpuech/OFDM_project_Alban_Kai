clear variables;
close all;
clc;
clear all;
addpath ./src

n_experiments = 1;

mul_range = (1:5);
mul_length = length(mul_range);
f_spacing_range = 0.25.*mul_range;

ber_list = zeros(mul_length,1);
for i=1:mul_length
    conf = conf_spacing(mul_range(i))
    ber = zeros(n_experiments,1);
    for j=1:n_experiments
        res = run_sim(conf);
        res.ber;
        ber(j) = res.ber;
    end
    ber_list(i) = mean(ber)
end



figure();
plot(f_spacing_range,ber_list)
