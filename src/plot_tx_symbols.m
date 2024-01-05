function plot_tx_symbols(tx_symbols, conf)
% Plots the symbols of the transmitted signal.
% Inputs:
%   tx_symbols - Array of transmitted symbols to be plotted.
%   conf - Configuration 
if conf.plot_tx_symbols == 1
    figure('name','Signal Sent')
    hold on
    plot(tx_symbols(:), 'o');
    xline(0,'--'); yline(0,'--');
    xlim([-5 5]); ylim([-5 5]);
    title('symbols','interpreter','latex','FontSize',16);

end
end
