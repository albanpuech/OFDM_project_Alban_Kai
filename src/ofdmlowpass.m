function [after] = ofdmlowpass(before,conf,f)
% % LOWPASS lowpass filter
% % Low pass filter for extracting the baseband signal 
% %
% %   before  : Unfiltered signal
% %   conf    : Global configuration variable
% %   f       : Corner Frequency
% %
% %   after   : Filtered signal
% %
% % Note: This filter is very simple but should be decent for most 
% % application. For very high symbol rates and/or low carrier frequencies
% % it might need tweaking.
% %
% 
% % after = lowpass(before,f,conf.f_s,StopbandAttenuation=0);
% h_lp=design(fdesign.lowpass('N,F3db',1,f,2*conf.f_s),'alliir');
% B=h_lp.ScaleValues(1);
% A=[1,h_lp.sosMatrix(5)];
% after = filter(B,A,before);
% 
% % LOWPASS lowpass filter
% % Low pass filter for extracting the baseband signal 
% %
% %   before  : Unfiltered signal
% %   conf    : Global configuration variable
% %   f       : Corner Frequency
% %
% %   after   : Filtered signal
% %
% % Note: This filter is very simple but should be decent for most 
% % application. For very high symbol rates and/or low carrier frequencies
% % it might need tweaking.
% %
after = lowpass(before,f,conf.f_s,StopbandAttenuation=30);

