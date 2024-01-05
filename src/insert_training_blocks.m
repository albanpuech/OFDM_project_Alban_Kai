function [tx_symbols, conf] = insert_training_blocks(tx_symbols, conf)
% Inserts training blocks into a sequence of transmission symbols.
% Inputs:
%   tx_symbols - transmission symbols
%   conf - Configuration 
% Outputs:
%   tx_symbols - transmission symbols with training blocks inserted.
tx_symbols = reshape(tx_symbols,[conf.ncarriers conf.nsymbs]); % reshape the txsymbols so as to have as many rows as number of carriers.
for i = 0 : conf.npilots - 1
    if i == 0 % start with a training block
        tx_symbols = [conf.training, tx_symbols];
    else 
        data_end_idx = i*conf.data_block_len+i; % insert training block between each data block that each contain conf.data_block_len data symbols 
        tx_symbols = [tx_symbols(:,1:data_end_idx), conf.training, tx_symbols(:,data_end_idx + 1 : end)];
    end
end