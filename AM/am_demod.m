function sig_demod = am_demod(base_iq_signal, fc, fs)

% ��ɷ���ɽ��(����첨)
% sΪ�����źţ�fcΪ�ز�Ƶ�ʣ�fsΪ����Ƶ��
% sig_demodΪ������ź�

t = linspace(0,length(base_iq_signal)/fs,length(base_iq_signal));
%ϣ�����ر任ȡģֵ
amp = abs(hilbert(base_iq_signal));      
%����Ҷ�任
[f,amf] = time_to_freq(t,amp); 
%ͨ����ͨ�˳���Ƶ����
[~,amp] = lpf(f,amf,fc); 
%��������
sig_demod = amp - mean(amp);                 

end