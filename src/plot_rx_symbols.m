function plot_rx_symbols(payload_data, conf)
if conf.plot_rx_symbols
    figure('name','Recieved Constellation')
    
        % hold on
        for k = 1 : conf.nsymbs
            rows = 5;
            cols = ceil(conf.nsymbs/5);
            subplot(rows,cols,k)
            plot(payload_data(:,k), 'o');
            xline(0,'--'); yline(0,'--');
            xlim([-3 3]); ylim([-3 3]);
            title(sprintf('Data Block %d', k),'FontSize',10);
            % title('Received symbols w/ correction','interpreter','latex','FontSize',10);
        end
end
end
