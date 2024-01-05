function txbits = mapper(txbits, modulation_order)
% Maps binary bits to symbols based on the specified modulation scheme.
% Inputs:
%   txbits -  bits to be mapped to symbols.
%   modulation_order - Modulation (1 for BPSK, 2 for QPSK).
% Outputs:
%   txbits - Mapped symbols according to the specified modulation order.

switch modulation_order
    case 1 % BPSK
        txbits = 1 - 2 * txbits;
    case 2 % QPSK
        bits = 2*(txbits-0.5);
        txbits   = 1/sqrt(2)*(bits(1:2:end) + 1j*bits(2:2:end));
end