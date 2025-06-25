function sig_psk = psk_mod(signal, msg_bits, samps_per_symb, init_phase)

tx_bits = [signal, msg_bits];
%spread
tx_bits = repmat(tx_bits.',1,samps_per_symb);
temp_invert = ~tx_bits;

f = 20;                     %本地频率
wfc = 2*pi*f;               %本地信号频率
ts = 1/samps_per_symb;      %积累时间为1ms
nn = [0:samps_per_symb-1];

base_carrier_p1 = exp(1i*(wfc*ts*nn+init_phase));  
base_carrier_p1 = repmat(base_carrier_p1,size(tx_bits,1),1);
base_carrier_p2 = exp(1i*(wfc*ts*nn+init_phase-pi));
base_carrier_p2 = repmat(base_carrier_p2,size(tx_bits,1),1);
 
sig_psk1 = tx_bits.*base_carrier_p1;
sig_psk2 = temp_invert.*base_carrier_p2;
sig_psk = (sig_psk1 + sig_psk2).';

sig_psk = reshape(sig_psk,size(sig_psk,1)*size(sig_psk,2),1);

end