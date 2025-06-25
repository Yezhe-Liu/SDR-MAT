function rx_info = fm_rx_func(rxdata)

rx_info = struct( 'training_seq', [], ... % have no use
                  'Amp', 1, ...
                  'fc', 20e3, ...
                  'fs', 100e3, ...
                  'audio_samp_freq', 20e3, ...%44.1e3
                  'kf', 2e4, ...
                  'base_iq_signal', []);
              
rx_info.base_iq_signal = rxdata.';
%Normalize signal to [-1, 1]
scale = max([max(real(rx_info.base_iq_signal)) max(imag(rx_info.base_iq_signal))]);
base_iq_signal = rx_info.base_iq_signal./scale;

sig_demod = fm_demod(base_iq_signal, rx_info.fs, rx_info.kf, rx_info.Amp); 

% sig_demod = fm_demod(base_iq_signal, rx_info.fc, rx_info.fs);   
rx_info.sig_demod = sig_demod;

rx_display(rx_info);

sound(sig_demod, rx_info.audio_samp_freq);    

end

