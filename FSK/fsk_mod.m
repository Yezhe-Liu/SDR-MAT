function sig_fsk = fsk_mod(signal, tx_bits, f1,f2, samps_per_symb)

tx_bits = [signal tx_bits];

t = 0:1/samps_per_symb:1-1/samps_per_symb;
base_carrier_f1 = exp(1i*2*pi*f1*t);
base_carrier_f2 = exp(1i*2*pi*f2*t);

sig_fsk = [];
for n=1:length(tx_bits)
    if tx_bits(n) == 0 
        sig_fsk = [sig_fsk base_carrier_f1];
    elseif tx_bits(n) == 1
        sig_fsk = [sig_fsk base_carrier_f2];
    end
end

sig_fsk = sig_fsk.';

end

