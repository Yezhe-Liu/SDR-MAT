function [ rx_info ] = qpsk_rx_func(rxdata, samp_rate)

rx_info = struct( 'modulationOrder', 4, ...
                  'len_preamble', 64, ...
                  'corr_peak_thresh', 0.55, ...
                  'RollOff', 0.5, ...
                  'NumOfTsSingleSide', 3, ...
                  'UpSampleRate', 10, ...
                  'SFD', [0 0 0 0 0 1 0 1 1 1 0 0 1 1 1 1], ...
                  'scramble_int', [1 0 0 1 0 1 0 1 0 0 0 0 0 0 0], ...
                  'InitState', 0, ...
                  'preamble_corr', [], ...
                  'msg_str', []);
              
rx_info.base_iq_signal = rxdata;
rx_info.samp_rate = samp_rate;
[ret, rx_info] =rx_search_packet(rx_info.base_iq_signal, rx_info);
if ret < 0
    msgbox('Could not find preamble!', 'Error','error');
    return;
end

rx_sig_fine = rxdata(rx_info.thres_idx:end);

% [rx_sig_fine, freq_est] = rx_frequency_sync_long(rx_sig_fine);

rx_preamble = rx_sig_fine(1:rx_info.len_preamble*2);
rx_sig_fine = rx_sig_fine(rx_info.len_preamble*2+1:end);
%Normalize signal to [-1, 1]
scale = max([max(real(rx_preamble)) max(imag(rx_preamble))]);
rx_sig_fine = rx_sig_fine./scale;
rx_sig_fine = rx_sig_fine.';

[sig_down_samp, rx_info] = rx_timing_recovery(rx_sig_fine, rx_info);

[sig_coarse_freq_sync, rx_info] = rx_fft_freq_sync(sig_down_samp, rx_info);

[rx_sig_carrier_sync, rx_info] = rx_carrier_sync(sig_coarse_freq_sync(1:100*60+8), rx_info);

[rx_sig_equalized, rx_info] = rx_time_equalize(rx_sig_carrier_sync, rx_info);

bitout = demod_dqpsk(rx_info.InitState, rx_sig_equalized);

bits_descramble = derandomizer(rx_info.scramble_int,bitout);

[frame_index] = rx_frame_sync(bits_descramble, rx_info.SFD);

if frame_index < 0
    msgbox('Could not find SFD!', 'Error','error');
    return;
end

msg_bits = bits_descramble(frame_index+1:end);

msg_bits = msg_bits(1:80*120);
str = bits_to_str(msg_bits.');
msg_str=reshape(str,15,length(str)/15).';
disp(msg_str);
rx_info.rx_sig_carrier_sync = rx_sig_carrier_sync;
rx_info.rx_sig_equalized = rx_sig_equalized;
rx_info.msg_str = msg_str;

end

