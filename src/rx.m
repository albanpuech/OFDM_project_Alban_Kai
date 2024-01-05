function [rxbits, conf] = rx(rxsignal, conf, k)
% Implements an OFDM receiver.
% Inputs:
%   rxsignal - Received signal to be processed.
%   conf - Configuration
% Outputs:
%   rxbits - received bits
% The function performs down-conversion, filtering, frame synchronization, removal of cyclic prefix, FFT-based demodulation, channel equalization, and bit demapping on the received OFDM signal.


% Down convert the signal (symmetric as how we upconverted it)
t = 0 : 1/conf.f_s : (length(rxsignal)-1)/ conf.f_s;
rxsignal = rxsignal.*exp(-1j*2*pi*(conf.f_c * t'));

% filter signal
filtered_rxsignal = 2*ofdmlowpass(rxsignal, conf, 1.05*conf.bw);

% run frame sync and get index of start of data
start_data_idx = frame_sync(filtered_rxsignal, conf);  
data_length = conf.os_factor*(conf.ncarriers + conf.cp_length)*conf.tot_symb; 
filtered_rxsignal = filtered_rxsignal(start_data_idx:start_data_idx + data_length - 1);

% go back to parallel 
rxsignal_p = reshape(filtered_rxsignal , [conf.os_factor*(conf.ncarriers + conf.cp_length),conf.tot_symb] );

% remove the cp - this is done by removing the first
% conf.os_factor*conf.cp_length samples of each multi carrier symbol i.e.
% the first conf.os_factor*conf.cp_length rows
rxsignal_p(1:conf.os_factor*conf.cp_length,:) = [];

% demodulate using osfft
for i = 1 : conf.tot_symb % loop over symbols
    rxsymbol(:,i) = osfft(rxsignal_p(:,i),conf.os_factor);
end

% run equalization
[payload_data, H_hat, conf] = equalize_channel(rxsymbol, conf);

% plot the channel
plot_rx_symbols(payload_data, conf);
plot_channel( H_hat, conf);
plot_power_delay_profile( H_hat, conf);
plot_channel_evolution( rxsymbol, conf)



% remove padding
payload_data = payload_data(:);
useful_bits = conf.nsymbs*conf.ncarriers*conf.modulation_order; 
payload_data(end-((useful_bits-conf.nbits)/conf.modulation_order)+1:end) = [];

% demap
rxbits = demapper(payload_data,conf.modulation_order);
