function [t,sig_time] = freq_to_time(f,sig_freq)   

% 信号的傅立叶反变换
% 输入参数，f为频率，sf为频域信号
% 输出参数，t为时间，st为是时域信号

%频率间隔
df = f(2)-f(1);
%频率长度
fmx = (f(end)-f(1)+df);        
dt = 1/fmx;  
%采样点数
N = length(sig_freq);   
%输出时间
T = dt*N;                        
t = 0:dt:T-dt;  
%校正频谱
sff = fftshift(sig_freq); 
%傅立叶反变换
sig_time = fmx*ifft(sff);                

end

%fftshift的作用正是让正半轴部分和负半轴部分的图像分别关于各自的中心对称。因为直接用fft得出的数据与频率不是对应的，fftshift可以纠正过来
