function [t,sig_time] = freq_to_time(f,sig_freq)   

% �źŵĸ���Ҷ���任
% ���������fΪƵ�ʣ�sfΪƵ���ź�
% ���������tΪʱ�䣬stΪ��ʱ���ź�

%Ƶ�ʼ��
df = f(2)-f(1);
%Ƶ�ʳ���
fmx = (f(end)-f(1)+df);        
dt = 1/fmx;  
%��������
N = length(sig_freq);   
%���ʱ��
T = dt*N;                        
t = 0:dt:T-dt;  
%У��Ƶ��
sff = fftshift(sig_freq); 
%����Ҷ���任
sig_time = fmx*ifft(sff);                

end

%fftshift�����������������Ჿ�ֺ͸����Ჿ�ֵ�ͼ��ֱ���ڸ��Ե����ĶԳơ���Ϊֱ����fft�ó���������Ƶ�ʲ��Ƕ�Ӧ�ģ�fftshift���Ծ�������
