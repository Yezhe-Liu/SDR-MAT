function rx_info = ask2_rx_func(rxdata)

rx_info = struct( 'training_seq', [], ... % have no use
                  'len_preamble', 64, ...
                  'corr_peak_thresh', 0.625, ...
                  'len_signal', 12, ...
                  'check_bit', [1; 0; 1; 0], ...
                  'samps_per_symb', 32, ...
                  'base_iq_signal',[], ...
                  'preamble_corr', [], ...
                  'rx_bits_len', [], ...
                  'rx_data_period', [], ...
                  'envelope', [], ...
                  'msg_str', []);
rx_info.base_iq_signal = rxdata;
[ret, thres_idx, preamble_corr] =rx_search_packet(rx_info.base_iq_signal, rx_info.len_preamble, rx_info.corr_peak_thresh);
if ret < 0
    msgbox('Could not find preamble!', 'Error','error');
    return;
end
rx_info.preamble_corr = preamble_corr;
rx_sig_fine = rxdata(thres_idx:end);
rx_preamble = rx_sig_fine(1:rx_info.len_preamble*2);

%Normalize signal to [-1, 1]
scale = max([max(real(rx_preamble)) max(imag(rx_preamble))]);
rx_sig_fine = rx_sig_fine./scale;

rx_signal_period = rx_sig_fine(rx_info.len_preamble*2+1: ...
                               rx_info.len_preamble*2+(rx_info.len_signal+length(rx_info.check_bit))*rx_info.samps_per_symb);
[rx_signal_bits,~] = ask_demod(rx_signal_period, rx_info.samps_per_symb);
check_bit = rx_signal_bits(rx_info.len_signal+1:end);
if check_bit ~= rx_info.check_bit
    msgbox('Rx signal Error!', 'Error','error');
    return;
end
rx_bits_len = bi2de(rx_signal_bits(1:rx_info.len_signal).','right-msb');
rx_info.rx_bits_len = rx_bits_len;
rx_data_period = rx_sig_fine(rx_info.len_preamble*2+(rx_info.len_signal+length(rx_info.check_bit))*rx_info.samps_per_symb+1: ...
                             rx_info.len_preamble*2+(rx_info.len_signal+length(rx_info.check_bit))*rx_info.samps_per_symb+ ...
                             rx_bits_len*rx_info.samps_per_symb);
rx_info.rx_data_period = rx_data_period;
[rx_data_bits, envelope]= ask_demod(rx_data_period, rx_info.samps_per_symb);
rx_info.envelope = envelope;
rx_info.msg_str = bits_to_str(rx_data_bits);

rx_display(rx_info);

end

