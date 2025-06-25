clearvars -except times;close all;warning off;
data_type='narrowband_communication';% [tone ieee802_11a narrowband_communication wideband_communication]
if(strcmp(data_type,'narrowband_communication'))
    yunsdr_init.samp=1.92e6;%1.92e6  521K-61M
    yunsdr_init.bw=200e3;
else
    yunsdr_init.samp=30.72e6;
    yunsdr_init.bw=20e3;
end
yunsdr_init.freq=93e6;            % tx LO freq 75e6~6000e6
yunsdr_init.rx_gain=20;              % rx gain 0~71
yunsdr_init.rx_chan=hex2dec('1');   % mask of rxch,1,2
[rxdata,sample_rate]=load_from_yunsdr(yunsdr_init);
yunsdr_init.samp=sample_rate;
switch data_type
    case 'tone'
        addpath Tone
        tone_rx_func(rxdata,yunsdr_init.samp);
        pause(0.1);
    case 'ieee802_11a'
        upsample=2;
        addpath OFDM\receiver_matlab
        [data_byte_recv,sim_options] = ieee802_11a_rx_func(rxdata(:,1),upsample);
    case 'narrowband_communication'
        type = 'FM';% ASK FSK PSK 4ASK GSM CPFSK AM FM 
        rx_info = rx_narrowband_communication(type, rxdata);
    case 'wideband_communication'
        type = 'BPSK';% QPSK BPSK SCFDE
        rx_info = rx_wideband_communication(type, rxdata, yunsdr_init.samp);
        if(~strcmp(type,'SCFDE'))
            rx_info_display;
        end
end