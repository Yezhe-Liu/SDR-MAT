function [f, sig_freq]=time_to_freq(t, sig_time)   

% �źŵĸ���Ҷ�任
% ���������tΪʱ�䣬stΪ��ʱ���ź�
% ���������fΪƵ�ʣ�sfΪƵ���ź�

%�źų���ʱ��                 
T = t(end);                       
df = 1/T;    
%��������
N = length(sig_time);   
%����ź�Ƶ��
f = -N/2*df:df:N/2*df-df;  
%����Ҷ�任
sig_freq = fft(sig_time); 
%У��Ƶ��
sig_freq = T/N*fftshift(sig_freq);            

end