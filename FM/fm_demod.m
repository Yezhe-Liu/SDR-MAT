function diff_fm3=fm_demod(FM,fs,kf,a)
%����ɽ��
%���������FMΪ�ѵ��źţ���fsΪ����Ƶ�ʣ�kfΪ��Ƶ�����ȣ�a�ǵ�Ƶ�źŵķ���
%���������diff_fm3Ϊ������ź�

%�����ź�ͨ��΢��������
t=linspace(0,length(FM)/fs,length(FM));

% �������΢���㷨�������㣬����ʱ��ϳ�
% for i=1:length(t)-1
%     diff_fm(i)=(FM(i+1)-FM(i))/(1/fs);
% end

   diff_fm=diff(FM)/(1/fs);                                    %����΢��
   diff_fm1 = abs(hilbert(diff_fm));                        %ϣ�����ر任�������ֵ�õ�˲ʱ���ȣ�����첨��
   
   %��������
   diff_fm2=diff_fm1-mean(diff_fm1);
   diff_fm2(length(t))=0;
   diff_fm3=diff_fm2/2/pi/a/kf;
   
end