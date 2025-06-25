function bitout = demod_dqpsk(InitState, rx_symbols_sync)

Hi = -1;
for i = 1:length(rx_symbols_sync)
    Hi = Hi+2;
    [bitout(Hi:Hi+1), InitState, ~] = DEQ(rx_symbols_sync(i).*exp(-1i*pi/4), InitState);
end


end

