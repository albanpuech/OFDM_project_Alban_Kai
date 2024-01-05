function [txsignal, conf] = tx(txbits, conf)
% Implements a complete transmitter with OFDM modulation.
% Inputs:
%   txbits - Array of binary bits to be transmitted.
%   conf - Configuration 
% Outputs:
%   txsignal - The OFDM-modulated and up-converted transmitted signal.
total_nbits = conf.nsymbs*conf.ncarriers*conf.modulation_order; % total number of bits to be sent
% insert the data to be sent and add random bits:
txbits = [txbits; randi([0 1],total_nbits-conf.nbits,1)]; 

% map data with the constellation of the right modulation order.
tx_symbols = mapper(txbits, conf.modulation_order);

% show the symbols that we sent  
plot_tx_symbols(tx_symbols, conf)

% add the training symbols to the data
[tx_symbols, conf] = insert_training_blocks(tx_symbols, conf);
conf.tx_symbols = tx_symbols;   

% Modulate signal with OFDM modulation
ofdm_symb = add_cp_and_modulate(tx_symbols, conf);
ofdm_symb = ofdm_symb(:);
 
% conv upsampled preamble with pulse
preamble = conv(upsample(conf.preamble, conf.os_factor_pre), conf.pulse','same');

% normalize power and add preamble
preamble_power = mean(abs(preamble).^2);         % preamble power
symbols_power = mean(abs(ofdm_symb).^2);       % symbols power
txsignal = [preamble/sqrt(preamble_power); ofdm_symb/sqrt(symbols_power)];

% up-convert signal
t = 0:1/conf.f_s: (length(txsignal) - 1)/conf.f_s;
txsignal = real(txsignal .* exp(1j*2*pi*conf.f_c*t'));

% plot ffc of the signal
plot_tx_fft(txsignal,conf);

