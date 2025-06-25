function rx_info = psk2_rx_func(rxdata)

rx_info = struct( 'len_training_seq', 4, ... % have 
                  'len_preamble', 64, ...
                  'corr_peak_thresh', 0.625, ...
                  'init_phase', 0, ...
                  'fc', 20, ...
                  'check_phase', [1; 0; 1; 0], ...
                  'len_signal', 12, ...
                  'check_bit', [1; 0; 1; 0], ...
                  'samps_per_symb', 1000, ...
                  'base_iq_signal',[], ...
                  'preamble_corr', [], ...
                  'rx_bits_len', [], ...
                  'rx_data_bits', [], ...
                  'msg_str', []);
rx_info.base_iq_signal = rxdata;
[ret, thres_idx, preamble_corr] =rx_search_packet(rxdata, rx_info.len_preamble, rx_info.corr_peak_thresh);
if ret == -1
    msgbox('Could not find preamble!', 'Error','error');
    return;
end
rx_info.preamble_corr = preamble_corr;
rx_sig_fine = rxdata(thres_idx:end);

rx_preamble = rx_sig_fine(1:rx_info.len_preamble*2);
rx_sig_fine = rx_sig_fine(rx_info.len_preamble*2+1:end);
%Normalize signal to [-1, 1]
scale = max([max(real(rx_preamble)) max(imag(rx_preamble))]);
rx_sig_fine = rx_sig_fine./scale;
% carrier recovery and demod bits
[rx_bits,sig_demod, sig_lpf, Sin_detect] = psk_demod(rx_sig_fine, rx_info.samps_per_symb);

rx_signal_bits = rx_bits(rx_info.len_training_seq+1:rx_info.len_training_seq+length(rx_info.check_phase)+ ...
                         rx_info.len_signal+length(rx_info.check_bit));
% phase ambiguity
rx_check_phase = rx_signal_bits(1:4);
if rx_check_phase == rx_info.check_phase
    rx_signal_bits = rx_signal_bits(5:end);
elseif rx_check_phase == ~(rx_info.check_phase)
    rx_signal_bits = ~rx_signal_bits(5:end);
else
    msgbox('Rx signal Error!', 'Error','error');
    return ;
end
% signal check
check_bit = rx_signal_bits(rx_info.len_signal+1:end);
if check_bit ~= rx_info.check_bit
    msgbox('Rx signal Error!', 'Error','error');
    return;
end
% frame length
rx_bits_len = bi2de(rx_signal_bits(1:rx_info.len_signal).','right-msb');
rx_info.rx_bits_len = rx_bits_len;
rx_data_bits = rx_bits(rx_info.len_training_seq+length(rx_info.check_phase)+rx_info.len_signal+length(rx_info.check_bit)+1: ...
                       rx_info.len_training_seq+length(rx_info.check_phase)+rx_info.len_signal+length(rx_info.check_bit)+rx_bits_len);
rx_info.rx_data_bits = rx_data_bits;

rx_info.sig_demod = sig_demod(1:rx_bits_len*rx_info.samps_per_symb);
rx_info.sig_lpf = sig_lpf(1:rx_bits_len*rx_info.samps_per_symb);
rx_info.rx_data_period = rx_sig_fine(1:rx_bits_len*rx_info.samps_per_symb);
rx_info.Sin_detect = Sin_detect(1:rx_bits_len*rx_info.samps_per_symb);

if  rx_check_phase == ~(rx_info.check_phase)
    rx_data_bits = ~rx_data_bits;
end
rx_info.rx_data_bits = rx_data_bits;

msg_str = bits_to_str(rx_data_bits);
rx_info.msg_str = msg_str;

rx_display(rx_info);

end