function sig_demod = am_demod(base_iq_signal, fc, fs)

% 完成非相干解调(包络检波)
% s为输入信号，fc为载波频率，fs为采样频率
% sig_demod为解调后信号

t = linspace(0,length(base_iq_signal)/fs,length(base_iq_signal));
%希尔伯特变换取模值
amp = abs(hilbert(base_iq_signal));      
%傅立叶变换
[f,amf] = time_to_freq(t,amp); 
%通过低通滤出低频分量
[~,amp] = lpf(f,amf,fc); 
%幅度修正
sig_demod = amp - mean(amp);                 

end