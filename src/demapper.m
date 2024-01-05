function [rxbits] = demapper(rx, modulation_order)
% Performs demapping of received symbols to bits.
% Inputs:
%   rx - Received symbols.
%   modulation_order - Order of the modulation (1 for BPSK, 2 for QPSK).
% Outputs:
%   rxbits - Demapped bits.
switch modulation_order
    case 1
        rxbits = 1-(rx > 0);
    case 2
        a = rx(:);
        b = [real(a) imag(a)] > 0;
        b = b.';
        b = b(:);
        rxbits = double(b);
end