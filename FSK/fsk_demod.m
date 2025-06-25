function [bits, sig_lpf1, sig_lpf2, rx_code] = fsk_demod(iq_signal, samps_per_symb)

% use bandpass filtering for filtering
% set bandpass parameters
bpf1 = fir1(101,[0.1 0.6]);
bpf2 = fir1(101,[0.6 0.8]);              
sig_bpf1 = filter(bpf1,1,iq_signal);
sig_bpf2 = filter(bpf2,1,iq_signal);  
% rectification filter
sig_bpf1_abs = abs(sig_bpf1);
sig_bpf2_abs = abs(sig_bpf2);

%Low frequency rectifier
lpf = fir1(101,0.1);
sig_lpf1=filter(lpf,1,sig_bpf1_abs);
sig_lpf2=filter(lpf, 1, sig_bpf2_abs);

rx_code = ones(size(sig_lpf1));
rx_code(sig_lpf1 > sig_lpf2) = 0;

bpf3 = fir1(101,0.05);
rx_code = filter(bpf3,1,rx_code);
rx_code(rx_code>=0.5) = 1;
rx_code(rx_code<0.5) = 0;
% sampling decision
bits = rx_code(samps_per_symb./2:samps_per_symb:end);

end

