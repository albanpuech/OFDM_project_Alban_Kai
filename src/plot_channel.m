function plot_channel( H_hat, conf)
if conf.plot_channel
        % Channel magnitude and phase
        f = 0 : conf.bw/conf.ncarriers : (conf.bw*(1-1/conf.ncarriers));
        f = f + conf.f_c - conf.bw/2;
        figure('name','channel magnitude and phase')
        subplot(2,1,1); plot(f,20*log10(abs(H_hat)./max(abs(H_hat))),'-', 'LineWidth', 2);
        xlim([f(1) f(end)]); xline(conf.f_c,'--r')
        xlabel('frequency/Hz','interpreter','latex','FontSize',16);
        ylabel('amplitude/dB','interpreter','latex','FontSize',16);
        title('Magnitude','interpreter','latex','FontSize',16);
        grid on
        subplot(2,1,2); plot(f,unwrap(angle(H_hat)),'-', 'LineWidth', 2);
        xlim([f(1) f(end)]); xline(conf.f_c,'--r')
        xlabel('frequency/Hz','interpreter','latex','FontSize',16);
        ylabel('degrees','interpreter','latex','FontSize',16);
        title('Phase','interpreter','latex','FontSize',16);
        grid on
end