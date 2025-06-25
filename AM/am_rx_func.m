function rx_info = am_rx_func(rxdata)

rx_info = struct( 'training_seq', [], ... % have no use
                  'fc', 20e3, ...
                  'fs', 100e3, ...
                  'audio_samp_freq', 44.1e3, ...
                  'base_iq_signal', []);
              
rx_info.base_iq_signal = rxdata.';
%Normalize signal to [-1, 1]
scale = max([max(real(rx_info.base_iq_signal)) max(imag(rx_info.base_iq_signal))]);
base_iq_signal = rx_info.base_iq_signal./scale;

sig_demod = am_demod(base_iq_signal, rx_info.fc, rx_info.fs);   
rx_info.sig_demod = sig_demod;

rx_display(rx_info);

%sound(sig_demod, rx_info.audio_samp_freq);
sound(sig_demod, rx_info.audio_samp_freq/2); 

end

