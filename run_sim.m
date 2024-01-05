function res = run_sim(conf)
% this function is inspired from the main file of the first project.
        addpath ./src
        
        % Initialize result structure with zero
        res.biterrors   = zeros(conf.nframes,1);
        res.rxnbits     = zeros(conf.nframes,1);
        
            % Results
        for k=1:conf.nframes
            % Generate random data
            txbits = randi([0 1],conf.nbits,1);
            
            % Transmit data
            [txsignal, conf] = tx(txbits,conf);
            
            % % % % % % % % % % % %
            % Begin
            % Audio Transmission
            %
    
            % normalize values
            peakvalue       = max(abs(txsignal));
            normtxsignal    = txsignal / (peakvalue + 0.3);
    
            % create vector for transmission
            rawtxsignal = [ zeros(conf.f_s,1) ; normtxsignal ;  zeros(conf.f_s,1) ];
            
            txdur       = length(rawtxsignal)/conf.f_s; % calculate length of transmitted signal
            audiowrite('out.wav',rawtxsignal,conf.f_s)  
    
            % Platform native audio mode 
            if strcmp(conf.audiosystem,'native')
    
                % Windows WAV mode 
                if ispc()
                    disp('Windows WAV');
                    wavplay(rawtxsignal,conf.f_s,'async');
                    disp('Recording in Progress');
                    rawrxsignal = wavrecord((txdur+1)*conf.f_s,conf.f_s);
                    disp('Recording complete')
                    rxsignal = rawrxsignal(1:end,1);
    
                % ALSA WAV mode 
                elseif isunix()
                    disp('Linux ALSA');
                    cmd = sprintf('arecord -c 2 -r %d -f s16_le  -d %d in.wav &',conf.f_s,ceil(txdur)+1);
                    system(cmd); 
                    disp('Recording in Progress');
                    system('aplay  ./data/out.wav')
                    pause(2);
                    disp('Recording complete')
                    rawrxsignal = audioread('in.wav');
                    rxsignal    = rawrxsignal(1:end,1);
                end
    
            % MATLAB audio mode
            elseif strcmp(conf.audiosystem,'matlab')
                disp('MATLAB generic');
                playobj = audioplayer(rawtxsignal,conf.f_s,conf.bitsps);
                recobj  = audiorecorder(conf.f_s,conf.bitsps,1);
                record(recobj);
                disp('Recording in Progress');
                playblocking(playobj)
                pause(0.5);
                stop(recobj);
                disp('Recording complete')
                rawrxsignal  = getaudiodata(recobj,'int16');
                rxsignal     = double(rawrxsignal(1:end))/double(intmax('int16')) ;
    
            elseif strcmp(conf.audiosystem,'bypass')
                rxsignal = rawtxsignal(:,1);

            elseif strcmp(conf.audiosystem,'AWGN_bypass') % This is an AWGN bypass channel with phase noise.
                rawrxsignal = rawtxsignal(:,1);
                sigmaDeltaTheta = conf.sigmaDeltatheta;
                theta_n = generate_phase_noise(length(rawrxsignal), sigmaDeltaTheta);
                % add phase noise
                rawrxsignal = rawrxsignal.*exp(1j*theta_n);
                % add AWGN
                SNRlin = 10^(conf.SNR/10);           
                rxsignal = rawrxsignal + sqrt(1/(2*SNRlin)) * (randn(size(rawrxsignal)) + 1i*randn(size(rawrxsignal))); 
            end
            %
            % End
            % Audio Transmission   
            % % % % % % % % % % % %
            
            % Receive data
            [rxbits, conf]      = rx(rxsignal,conf);
            res.rxnbits(k)      = length(rxbits);  
            res.biterrors(k)    = sum(rxbits ~= txbits);
    
        end
       
       res.per = sum(res.biterrors > 0)/conf.nframes;
       res.ber = sum(res.biterrors)/sum(res.rxnbits)+1e-6;
end
