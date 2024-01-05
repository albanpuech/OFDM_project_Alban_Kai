function ofdm_symb = add_cp_and_modulate(symbols, conf)
% Adds a cyclic prefix to OFDM symbols and performs modulation.
% Inputs:
%   symbols - Matrix of OFDM symbols.
%   conf - Configuration.
% Outputs:
%   ofdm_symb - Modulated OFDM symbols with cyclic prefix.

    ofdm_symb = zeros((conf.ncarriers + conf.cp_length)*conf.os_factor,size(symbols,2)); % pre-allocate enough rows to add the CP and take into account the oversampling factor.
    for i = 1 : size(symbols,2) % loop over each multicarrier symbol
        % start with cyclic prefix. We simply add the last samples (!=
        % symbols !!!) as first samples of each ofdm symbol)
        ofdm_symb(1:conf.os_factor*conf.cp_length,i) = ofdm_symb(end-conf.os_factor*conf.cp_length+1:end,i);
        % add the rest of the samples
        ofdm_symb(conf.os_factor*conf.cp_length+1:end,i) = osifft(symbols(:,i),conf.os_factor);

    end
end