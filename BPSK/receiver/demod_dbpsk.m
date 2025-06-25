function bitout = demod_dbpsk(InitState, rx_symbols_sync)

Hi = 0;

for i = 1:length(rx_symbols_sync)
    Hi = Hi+1;
    [bitout(Hi), InitState, ~]=DEB(rx_symbols_sync(i).*exp(-1i*pi/4), InitState);
end

end

