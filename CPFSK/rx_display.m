function rx_display(rx_info, config_info)

h = figure(1);clf;
set(h,'units','normalized','position',[0.1 0.1 0.8 0.8]);
rxdata = rx_info.base_iq_signal;
%time vector: 1/Fs increments
t = 0 : length(rxdata)-1;
%RX IQ samples
subplot(231);
plot(t, real(rxdata));
hold on;
plot(t, imag(rxdata));
title('RX raw IQ samples vs time');
%RX raw spectrum
subplot(232);
if (exist('OCTAVE_VERSION', 'builtin') ~= 0)
    pwelch(rxdata, [], [], 256, config_info.Fs, 'centerdc');
else
    pwelch(rxdata, [], [], [], config_info.Fs, 'centered');
end
title('RX raw spectrum');
%RX filtered IQ samples
subplot(233);
plot(real(rx_info.iq_filt_norm));
hold on;
plot(imag(rx_info.iq_filt_norm));
title('RX filtered & normalized IQ samples');
%RX cross correlation with preamble. Plot power (i^2 + q^2).
subplot(234);
plot(abs(rx_info.preamble_corr).^2);
title('RX cross correlation with preamble (power)');
%RX dphase (data signal only, training/preamble not included)
subplot(235);
if (rx_info.dphase ~= -1)
    plot(rx_info.dphase);
    title('RX dphase (data signal only)');
end
subplot(236);
text(0.1,0.6,['数据长度: ',num2str(length(rx_info.rx_bits)),' bytes']);
text(0.1,0.3,['数据信息: ',char(bin2dec(rx_info.rx_bits).')]);
fprintf('Received: ''%s''\n', bin2dec(rx_info.rx_bits));
axis off;
end

