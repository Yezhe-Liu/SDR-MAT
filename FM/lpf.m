function [t,st] = lpf(f, sig_freq, Bw) 

% ��ͨ�˲���
% ���������fΪƵ�ʣ�sfΪƵ���źţ�BΪ�����ͨ�˲�������
% ���������tΪʱ�䣬stΪ��ʱ���ź�

%Ƶ�ʼ��
df=f(2)-f(1);                                                                                    
hf = zeros(1,length(f)); 
%��ͨ�˲���ͨ����Χ
bf = [-floor(Bw/df):floor(Bw/df)]+floor(length(f)/2);    
%ͨ����ֵ����0
hf(bf) = 1; 
%�ź�ͨ�������ͨ�˲���
yf = hf.*sig_freq;   
%����Ҷ���任
[t,st] = freq_to_time(f,yf); 
%ȡʵ��
st = real(st);                                                    

end