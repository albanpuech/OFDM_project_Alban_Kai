function [payload_data, H_hat, conf] = equalize_channel(signal, conf)
% Performs channel equalization on the signal.
% Inputs:
%   signal - Input signal
%   conf - Configuration
% Outputs:
%   payload_data - Equalized payload data.
%   H_hat - Estimated channel response.
%   conf - Configuration


payload_data = zeros(conf.ncarriers, conf.nsymbs); % pre-allocate payload data array
pilot_index = 0;
data_index_to_correct = 0;

%%%%%%%%%%%%%% BLOCK TYPE CHANNEL ESTIMATION AND CORRECTION%%%%%%%%%%%%%%
if conf.phase_tracking_alg == 0  
    
    % loop over each pilot
    for i = 1 : conf.data_block_len + 1 : size(signal,2)
        pilot_index = pilot_index + 1; %increment pilot index != data index where the pilot is located
        H_hat(:,pilot_index) = signal(:,i)./conf.training; % compute H
        for k = 1 : conf.data_block_len 
            data_index_to_correct = data_index_to_correct + 1;
            if data_index_to_correct > conf.nsymbs  % out of range so we stop correcting the symbols
                continue
            end
            current_symbol_index = i + k;
            payload_data(:,data_index_to_correct) = signal(:,current_symbol_index)./abs(H_hat(:,pilot_index));
            payload_data(:,data_index_to_correct) = payload_data(:,data_index_to_correct).*exp(-1j*mod(angle(H_hat(:,pilot_index)),2*pi));
        end    
    end
%%%%%%%%%%%%%% BLOCK + VITURBI %%%%%%%%%%%%%%
elseif conf.phase_tracking_alg == 1  
    % estimate channel for each pilot to have initial estimates (one for
    % each data block that follows a pilot)
    for i = [1 : conf.data_block_len + 1 : size(signal,2)]
        pilot_index = pilot_index + 1;
        H_hat(:,pilot_index) = signal(:,i)./conf.training;
        
        % start with the estimate and improve it at each symbol of the data block by doing
        % viturbi-viturbi
        for k = 1 : conf.data_block_len 
            data_index_to_correct = data_index_to_correct + 1;
            if data_index_to_correct > conf.nsymbs
                continue
            end
            current_symbol_index = i + k;  
            payload_data(:,data_index_to_correct) = signal(:,current_symbol_index);  % current symbol
            deltaTheta = 1/4*angle(-payload_data(:,data_index_to_correct).^4) + pi/2*(-1:4);
            if k == 1
                % we start with the initial estimate obtained from the
                % pilot
                theta = mod(angle(H_hat(:,pilot_index)),2*pi);
            else %we correct the previous estimate so we start from the previous theta
                theta = theta_hat(:,data_index_to_correct-1);
            end
            % find the right quadrant as in the exercises
            [~, ind] = min(abs(deltaTheta - theta),[],2);
            indvec = (0:conf.ncarriers-1).*6 + ind'; 
            deltaTheta = deltaTheta';
            theta0 = deltaTheta(indvec)';
            theta_hat(:,data_index_to_correct) = mod(0.01.*theta0 + 0.99.*theta, 2*pi);
            % Correct the phase offset
            payload_data(:,data_index_to_correct) = payload_data(:,data_index_to_correct) .* exp(-1j * theta_hat(:,data_index_to_correct))./abs(H_hat(:,pilot_index)); 
        end
    end
%%%%%%%%%%%%% ONE BLOCK ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only one block = we perform channel estimation only once
else 
    H_hat = signal(:,1)./conf.training;
    for k = 1 : conf.nsymbs % correct all symbols using initial channel estimate only
        payload_data(:,k) = signal(:,k+1)./abs(H_hat);
        payload_data(:,k) = payload_data(:,k).*exp(-1j*mod(angle(H_hat),2*pi));
    end
end