function [f, sig_freq]=time_to_freq(t, sig_time)   

% 信号的傅立叶变换
% 输入参数，t为时间，st为是时域信号
% 输出参数，f为频率，sf为频域信号

%信号持续时间                 
T = t(end);                       
df = 1/T;    
%采样点数
N = length(sig_time);   
%输出信号频率
f = -N/2*df:df:N/2*df-df;  
%傅立叶变换
sig_freq = fft(sig_time); 
%校正频谱
sig_freq = T/N*fftshift(sig_freq);            

end