function sig_am = am_mod(sig_audio, Amp, fc, fs)

sig_audio = sig_audio.';
%ʱ�䳤��Ϊ����ʱ�䣬��������Ϊfs
t = linspace(0, (length(sig_audio)-1)/fs,length(sig_audio));                          
carrier = exp(1i*2*pi*fc*t);
 %�ѵ��ź�
sig_am = (Amp+sig_audio).*carrier;

end

