function [out_signal,rx_info] = rx_time_equalize(rx_sig_carrier_sync, rx_info)

rx_sig_carrier_sync=[zeros(1,13) rx_sig_carrier_sync zeros(1,5)];
N=length(rx_sig_carrier_sync);
M=10;                   %均衡器的阶数
W=zeros(M+1,1);         %初始化抽头系数
W(ceil(((M+1)/2)))=1;   %初始化
U=1e-3/2;                 %设置收敛步长
Y1=zeros(M+1,1);
e=zeros(1,(N-M));       %初始化误差
R1=1;
R2=1;
for mmm=1:4
    for n=1:(N-M)
        Y1=rx_sig_carrier_sync(n+M:-1:n).';
        YK(n)=W.'*Y1;   %均衡器的输出
        YI=real(YK(n));
        YQ=imag(YK(n));
        EI=YI*(YI^2-R1);
        EQ=YQ*(YQ^2-R2);
        e(n)=EI+EQ*sqrt(-1);
        W=W-U*e(n)*conj(Y1);%调节抽头系数
    end
end 
out_signal=YK(9:end);
rx_info.equalize_error = e;

end