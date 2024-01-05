function plot_channel_evolution( rxsymbol, conf)
if conf.plot_channel_evolution
    % Channel frequency response over time
    channel_imp = rxsymbol./conf.tx_symbols;
    chan_plot = [1 conf.ncarriers/2 conf.ncarriers];
    t = 0 : 1/conf.f_spacing : 1/conf.f_spacing*(conf.tot_symb - 1);

    figure('name','channel freq response vs time');
    subplot(2,1,1);
    plot(t,20*log10(abs(channel_imp(chan_plot(:),:))./max(abs(channel_imp(chan_plot(:),:)),[],2)),'-', 'LineWidth', 2);
    xlim([t(1) t(end)]);
    grid on
    xlabel('time/s','interpreter','latex','FontSize',16);
    ylabel('amplitude/dB','interpreter','latex','FontSize',16);
    title('Magnitude','interpreter','latex','FontSize',16);
    subplot(2,1,2); plot(t,unwrap(angle(channel_imp(chan_plot,:))),'-', 'LineWidth', 2);
    xlim([t(1) t(end)]);
    grid on
    xlabel('time/s','interpreter','latex','FontSize',16);
    ylabel('degrees','interpreter','latex','FontSize',16);
    title('Phase','interpreter','latex','FontSize',16);
end

end
