function [bits, sig_demod, sig_lpf, Sin_detect] = psk_demod(iq_signal, samps_per_symb)

bpf = fir1(101, [19/500, 21/500]);
% iq_signal = filter(bpf, 1, iq_signal);

num_symbols = floor(length(iq_signal)./samps_per_symb);
iq_signal = iq_signal(1:samps_per_symb.*num_symbols).';

[local_carrier, Sin_detect] = carrier_recovery(iq_signal);
local_carrier = local_carrier(1:end-1);

lpf = fir1(51, [1/250, 10/250]);

sig_demod = iq_signal.*local_carrier;
sig_lpf = filter(lpf, 1,sig_demod);

sig_symbols = sig_lpf(samps_per_symb./2:samps_per_symb:end);

rx_code(real(sig_symbols)>=0) = 1;
rx_code(real(sig_symbols)<0) = 0;
bits = rx_code.';

end