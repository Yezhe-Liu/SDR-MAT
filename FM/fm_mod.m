function sig_fm = fm_mod(sig_audio, Amp, fc, fs, kf)

sig_audio = sig_audio.';
%ʱ�䳤��Ϊ����ʱ�䣬��������Ϊfs
t = linspace(0, (length(sig_audio)-1)/fs,length(sig_audio));                          

%���ź�x(t)�Ļ���
s_int = cumsum(sig_audio)/fs;
%��Ƶ�ź�
sig_fm_i = Amp*cos(2*pi*fc*t + 2*pi*kf*s_int);                          
sig_fm_q = Amp*sin(2*pi*fc*t + 2*pi*kf*s_int);
sig_fm = sig_fm_i+1i*sig_fm_q;
end

