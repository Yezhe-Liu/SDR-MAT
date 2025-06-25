function [out_signal, freq_est] = rx_frequency_sync_long(rxsignal)
D = 64; 
phase = rxsignal(1:64).*conj(rxsignal(65:128));   
% add all estimates 
phase = sum(phase); 
freq_est = -angle(phase) / (2*D*pi/20000000);
radians_per_sample = 2*pi*freq_est/20000000;
% Now create a signal that has the frequency offset in the other direction
time_base=[0:length(rxsignal)-1].';
correction_signal=exp(-1i*radians_per_sample*time_base).*64;
% [a7 a8]=textread('E:\code\ieee802_11a\receiver_v_vivado\txt\dds_long.dat');
% corr_data=a7+1i*a8;
% correction_signal1=corr_data;
% And finally apply correction on the signal
out_signal = rxsignal.*correction_signal(1:length(rxsignal));