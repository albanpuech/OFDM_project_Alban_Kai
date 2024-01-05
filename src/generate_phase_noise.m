function theta_n = generate_phase_noise(length_of_noise, sigmaDeltaTheta)
% Generates phase noise for signal processing.
% Inputs:
%   length_of_noise - Length of the phase noise sequence to generate.
%   sigmaDeltaTheta - Standard deviation of the phase noise increments.
% Outputs:
%   theta_n - Generated phase noise sequence.
    theta_n = zeros(length_of_noise,1);
    theta_n(2:end) = randn(length_of_noise-1,1) * sigmaDeltaTheta;
    theta_n(1) = rand() * 2*pi;
    theta_n=cumsum(theta_n);
end


  