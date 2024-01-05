function plot_power_delay_profile( H_hat, conf)
if conf.plot_power_delay_profile
    % Channel Impulse response
    t = 0 : 1/conf.f_s : conf.ncarriers/conf.f_s-1/conf.f_s;
    figure('name','channel impulse response')
    fft_h_hat = ifft(H_hat,[],1);
    plot(t,abs(fft_h_hat),'-', 'LineWidth', 2);
    xlim([t(1) t(end)]);
    grid on
    title('Channel impulse response','interpreter','latex','FontSize',16);
    xlabel('time (s)','interpreter','latex','FontSize',16)
end