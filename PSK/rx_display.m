function rx_display(rx_info)

h = figure(1);clf;
set(h,'units','normalized','position',[0.1 0.1 0.8 0.8], 'defaultfigurecolor','w');
subplot(241);
plot(real(rx_info.base_iq_signal));
hold on;
plot(imag(rx_info.base_iq_signal));
grid on;
title('���������ź�');
subplot(242);
plot(rx_info.preamble_corr, 'r', 'LineWidth', 1.5);
grid on;
title('֡ͬ���������');
subplot(243);
plot(real(rx_info.rx_data_period));
hold on;
plot(imag(rx_info.rx_data_period));
grid on;
title('ͬ���������ź�');
subplot(244);
pwelch(rx_info.rx_data_period,[],[],[],20e6,'centered','psd');
title('�����źŹ�����');
subplot(245);
plot(rx_info.Sin_detect,'r');
grid on;
title('�ز�����');
subplot(246);
plot(real(rx_info.sig_demod));
hold on;
plot(imag(rx_info.sig_demod));
grid on;
% ylim([-1 0.51]);
title('��������źţ�');
subplot(247);
plot(real(rx_info.sig_lpf));
hold on;
plot(imag(rx_info.sig_lpf));
grid on;
% ylim([-1 1]);
title('��ͨ�˲��źţ�');
subplot(248);
text(0.1,0.6,['���ݳ���: ',num2str(rx_info.rx_bits_len./8),' bytes']);
text(0.1,0.3,['������Ϣ: ',num2str(rx_info.msg_str)]);
axis off;

end

