function [out_signal, freq_est] = rx_frequency_sync_long(rxsignal)
%频率同步，通过估计和矫正频率偏移实现
D = 64; %样本数
phase = rxsignal(1:64).*conj(rxsignal(65:128));   %此样本组与下一的共轭的诸葛乘积
% add all estimates 
phase = sum(phase); %相加，相位包含频偏信息
freq_est = -angle(phase) / (2*D*pi/4000000);%计算复数 phase 的相位（角度），并将其转换为频率偏移的估计值。这里假设采样频率为4000000 Hz
radians_per_sample = 2*pi*freq_est/4000000;%计算每个样本的相位偏移
% Now create a signal that has the frequency offset in the other direction
time_base=[0:length(rxsignal)-1].';%创建时间基向量，长度与信号相同
correction_signal=exp(-1i*radians_per_sample*time_base).*64;%生成一个复数指数信号，用于校正频率偏移。这个信号的频率与估计的频率偏移相反。
% [a7 a8]=textread('E:\code\ieee802_11a\receiver_v_vivado\txt\dds_long.dat');
% corr_data=a7+1i*a8;
% correction_signal1=corr_data;
% And finally apply correction on the signal
out_signal = rxsignal.*correction_signal(1:length(rxsignal));%将接收信号与校正信号相乘，以校正频率偏移。