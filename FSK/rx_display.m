function rx_display(rx_info)

h = figure(1);clf;
set(h,'units','normalized','position',[0.1 0.1 0.8 0.8],'defaultfigurecolor','w');

subplot(241);
plot(real(rx_info.base_iq_signal));
hold on;
plot(imag(rx_info.base_iq_signal));
grid on;
title('基带接收信号');
subplot(242);
plot(rx_info.preamble_corr, 'r', 'LineWidth', 1.5);
grid on;
title('帧同步相关曲线');
subplot(243);
plot(real(rx_info.rx_data_period));
hold on;
plot(imag(rx_info.rx_data_period));
grid on;
title('同步数据域信号');
subplot(244);
pwelch(rx_info.rx_data_period,[],[],[],'centered','psd');
title('数据信号功率谱');
subplot(245);
plot(rx_info.sig_lpf1, 'b');
grid on;
% ylim([-0.5 1.5]);
title('低频整流');
subplot(246);
plot(rx_info.sig_lpf2, 'r');
grid on;
% ylim([-0.5 1.5]);
title('高频整流');
subplot(247);
plot(rx_info.msg_bits);
title('解调码元信号', 'LineWidth', 2);
ylim([-0.5 1.5]);
subplot(248);
text(0.1,0.6,['数据长度: ',num2str(rx_info.rx_bits_len./8),' bytes']);
text(0.1,0.3,['数据信息: ',num2str(rx_info.msg_str)]);
axis off;

end

