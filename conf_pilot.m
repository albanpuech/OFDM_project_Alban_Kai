function conf = conf_pilot(data_block_len)
   
        %%%%%%%%%%%%%%% MAIN PARAMS %%%%%%%%%%%%%%%%
        conf.audiosystem = 'AWGN_bypass'; % Values: 'matlab','native','bypass'
        conf.f_s        = 48000;                % sampling rate  
        conf.f_sym_pre  = 500;                  % preamble symbol rate
        conf.nframes    = 1;                    % number of frames
        conf.modulation_order = 2;              % Modulation order
        conf.ncarriers  = 2^8;                 % number of sub carriers 
        conf.nbits      = 20*conf.modulation_order * conf.ncarriers;   % number of bits
        % conf.nbits      = 10*conf.ncarriers+6;  % number of bits 
        conf.cp_length  = 64;                   % length of cyclic prefix
        conf.f_spacing  = 10;                    % spacing 
        conf.f_c        = 8e3;                  % carrier frequency
        conf.bw         = ceil((conf.ncarriers +1)/2)*conf.f_spacing;     % bandwidth
        conf.npreamble  = 100;                  % length of preamble
        conf.sigmaDeltatheta = 0.005;           % variance of random walk increment for the phase noise
        conf.SNR = 25;
        conf.detection_threshold_preamble = 30; % detection threshold for the preamble
        conf.bitsps     = 16;                   % bits per audio sample  
        conf.data_block_len = data_block_len;  % data symbols between each pilot

        %%%%%%%%%%%%%%%% PLOT BOOLEAN %%%%%%%%%%%%%%%
        conf.plot_tx_symbols = 0;               
        conf.plot_tx_fft = 0;
        conf.plot_rx_symbols = 0;
        conf.plot_channel = 0;
        conf.plot_power_delay_profile=0;
        conf.plot_channel_evolution = 0;


        %%%%%%%%%%%%%% CHANNEL ESTIMATION ###%%%%%%%%%%%%
        % conf.phase_tracking_alg = 0 : Block estimation
        % conf.phase_tracking_alg = 1 : Viterbi-Viterbi
        % conf.phase_tracking_alg = 2 : Channel estimation using one block
        conf.phase_tracking_alg = 1;     
                                   

        %%%%%%%%%%%%%%% INIT OTHER PARAMS %%%%%%%%%%%%%
        % oversampling factor for OFDM symbols
        conf.os_factor  = conf.f_s/conf.f_spacing/conf.ncarriers;   
        % oversampling factor for preamble
        conf.os_factor_pre = conf.f_s/conf.f_sym_pre;

        if mod(conf.os_factor_pre,1) ~= 0
           disp('WARNING: Sampling rate must be a multiple of the symbol rate'); 
        end

        conf.data_length    = conf.nbits/conf.modulation_order;   % data length
        conf.nsymbs         = ceil(conf.data_length/...
                                conf.ncarriers);       % number of OFDM symbols 
        if conf.phase_tracking_alg == 2 % if only one training block for training
            conf.npilots = 1;
        else % compute number of pilots based on number length of data blocks
            conf.npilots    = ceil(conf.nsymbs/...
                                conf.data_block_len);       
        end

        % Total Symbols in transmission (Data + Training)
        conf.tot_symb = conf.nsymbs +  conf.npilots;

        %------------------------------------------------------------------
        conf.preamble	= 1 - 2*lfsr_framesync(conf.npreamble); % init preamble
        conf.training	= 1 - 2*randi([0 1],conf.ncarriers,1);  % init training sequence
        tx_filterlen = 10*conf.os_factor_pre;   % init filter len
        rolloff_factor = 0.22;
        conf.pulse      = rrc(conf.os_factor_pre,rolloff_factor, tx_filterlen);      % init pulse shape
end