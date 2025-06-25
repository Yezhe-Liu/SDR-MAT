function [sig_coarse_freq_sync, rx_info] = rx_fft_freq_sync(sig_down_samp, rx_info)

modulationOrder = rx_info.modulationOrder;
symbol_rate = rx_info.samp_rate./rx_info.UpSampleRate; 

offsetEstimates = fftFreqEst(modulationOrder, symbol_rate, sig_down_samp);
radians_per_sample = 2*pi*offsetEstimates(1)/symbol_rate;
% Now create a signal that has the frequency offset in the other direction
time_base=[0:length(sig_down_samp)-1].';
correction_signal=exp(-1i*radians_per_sample*time_base);

sig_coarse_freq_sync = sig_down_samp.*correction_signal(1:length(sig_down_samp)).';

rx_info.freq_offset = offsetEstimates(1);
end

