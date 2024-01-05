function plot_tx_fft(txsignal, conf)
% Plots the frequency spectrum of a transmitted signal.
% Inputs:
%   txsignal - transmitted signal
%   conf - Configuration 
if conf.plot_tx_fft
    figure('name','spectrum_tx_signal');
    % Compute fft of the transmitted signal
    x = - conf.f_s/2 : conf.f_s/length(txsignal) : conf.f_s/2 - conf.f_s/length(txsignal);
    % Get amplitude
    Y = abs(fftshift(fft(txsignal)));
    plot(x,Y)
    grid on
    title('Spectrum of the transmitted signal','interpreter','latex','FontSize',16);
    xlabel('Frequency [Hz]','interpreter','latex','FontSize',16);
    ylabel('Amplitude','interpreter','latex','FontSize',16);
    xline(conf.f_c,'--r'); xline(- conf.f_c,'--r');
    legend("txsignal", "carrier frequency");
end
end