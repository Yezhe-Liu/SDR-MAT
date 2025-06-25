function [t,st] = lpf(f, sig_freq, Bw) 

% 低通滤波器
% 输入参数，f为频率，sf为频域信号，B为理想低通滤波器带宽
% 输出参数，t为时间，st为是时域信号

%频率间隔
df=f(2)-f(1);                                                                                    
hf = zeros(1,length(f)); 
%低通滤波器通带范围
bf = [-floor(Bw/df):floor(Bw/df)]+floor(length(f)/2);    
%通带内值都赋0
hf(bf) = 1; 
%信号通过理想低通滤波器
yf = hf.*sig_freq;   
%傅立叶反变换
[t,st] = freq_to_time(f,yf); 
%取实部
st = real(st);                                                    

end