function beginning_of_data = frame_sync(rx_signal, conf)
% Frame synchronization on a received signal.
% Based on single carrier lab
% Inputs:
%   rx_signal - The received noisy signal to be synchronized.
%   conf - Configuration 
% Outputs:
%   beginning_of_data - Index of the first data symbol in rx_signal.

if (rx_signal(1) == 0)
    warning('Signal seems to be noise-free. The frame synchronizer will not work in this case.');
    
end

% solutions from exercise session
current_peak_value = 0;
L = conf.os_factor_pre;
samples_after_threshold = L;
rx_signal = conv(rx_signal, conf.pulse,'same');
for i = L * conf.npreamble + 1 : length(rx_signal)

    r = rx_signal(i - L *  conf.npreamble : L : i - L); 
    c = conf.preamble' * r;
    T = abs(c)^2 / abs(r' * r);
    if (T > conf.detection_threshold_preamble || samples_after_threshold < L)
        samples_after_threshold = samples_after_threshold - 1;
        if (T > current_peak_value)
            beginning_of_data = i;
            current_peak_value = T;
        end
        if (samples_after_threshold == 0)
            return;
        end
    end
    
end

error('No synchronization sequence found.');
return