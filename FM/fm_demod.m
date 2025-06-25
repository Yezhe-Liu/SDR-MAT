function diff_fm3=fm_demod(FM,fs,kf,a)
%非相干解调
%输入参数，FM为已调信号，，fs为抽样频率，kf为调频灵敏度，a是调频信号的幅度
%输出参数，diff_fm3为解调后信号

%接收信号通过微分器处理
t=linspace(0,length(FM)/fs,length(FM));

% 用下面的微分算法进行运算，计算时间较长
% for i=1:length(t)-1
%     diff_fm(i)=(FM(i+1)-FM(i))/(1/fs);
% end

   diff_fm=diff(FM)/(1/fs);                                    %进行微分
   diff_fm1 = abs(hilbert(diff_fm));                        %希尔伯特变换，求绝对值得到瞬时幅度（包络检波）
   
   %调整幅度
   diff_fm2=diff_fm1-mean(diff_fm1);
   diff_fm2(length(t))=0;
   diff_fm3=diff_fm2/2/pi/a/kf;
   
end