function rx_display(rx_info)

h = figure(1);clf;
set(h,'units','normalized','position',[0.1 0.1 0.8 0.8]);

subplot(231);
plot(real(rx_info.base_iq_signal));
hold on;
plot(imag(rx_info.base_iq_signal));
grid on;
title('���������ź�');
subplot(232);
plot(rx_info.preamble_corr, 'r', 'LineWidth', 1.5);
grid on;
title('֡ͬ���������');
subplot(233);
plot(real(rx_info.rx_data_period));
hold on;
plot(imag(rx_info.rx_data_period));
grid on;
title('ͬ���������ź�');
subplot(234);
pwelch(rx_info.rx_data_period,[],[],[],20e6,'centered','psd');
title('�����źŹ�����');
subplot(235);
plot(rx_info.envelope, 'b', 'LineWidth', 2);
grid on;
ylim([-0.5 1.5]);
title('����첨��');
subplot(236);
text(0.1,0.6,['���ݳ���: ',num2str(rx_info.rx_bits_len./8),' bytes']);
text(0.1,0.3,['������Ϣ: ',num2str(rx_info.msg_str)]);
axis off;

end

