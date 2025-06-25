function sig_ask = ask_mod(signal, msg_bits, samps_per_symb)

tx_bits = [signal, msg_bits];
len_bits = length(tx_bits);

%spread
tx_bits = repmat(tx_bits.',1,samps_per_symb);
tx_bits = reshape(tx_bits.',1,len_bits.*samps_per_symb);

carrier_i = cos(2*pi/samps_per_symb*[0:samps_per_symb-1]);
carrier_q = sin(2*pi/samps_per_symb*[0:samps_per_symb-1]);
carrier_i = repmat(carrier_i,1,len_bits);
carrier_q = repmat(carrier_q,1,len_bits);
carrier = carrier_i+1i*carrier_q;

sig_ask = (tx_bits.*carrier).';

end

