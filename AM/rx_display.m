function rx_display(rx_info)

figure(1);clf;
subplot(221);
plot(real(rx_info.base_iq_signal));
hold on;
plot(imag(rx_info.base_iq_signal));
grid on;
title('���������ź�');
subplot(222);
pwelch(rx_info.base_iq_signal, [],[],[],'centered','psd');
% axis square;
subplot(223);
plot(rx_info.sig_demod);
title('��������ź�');
grid on;
subplot(224);
pwelch(rx_info.sig_demod, [],[],[],'centered','psd');
% axis square;
end

