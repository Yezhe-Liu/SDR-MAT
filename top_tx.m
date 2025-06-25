clearvars -except times;close all;warning off;
source='tone';% [tone ieee802_11a narrowband_communication wideband_communication]
switch source
    case 'tone'
        addpath Tone
        yunsdr_init.samp=30.72e6;
        yunsdr_init.bw=20e3;%20e6  RTL应该只有1.4M
        txdata = tone_tx_func(yunsdr_init.samp);
    case 'ieee802_11a'
        addpath OFDM\transmitter_matlab
        yunsdr_init.samp=30.72e6;
        yunsdr_init.bw=20e6;
        in_byte=repmat(1:96,1,5);
        rate=54;
        upsample=2;
        tx_11a=ieee802_11a_tx_func(in_byte,rate,upsample);
        txdata=repmat([zeros(size(tx_11a));tx_11a],1,1);
    case 'narrowband_communication'
        type = 'FM';% ASK FSK PSK 4ASK GSM CPFSK AM FM 
        yunsdr_init.samp=1.92e6;%2.048e6  1.92
        yunsdr_init.bw=200e3; %75e3
        tx_info = tx_narrowband_communication(type);%传入type参数，接收返回的结构体
        txdata = tx_info.base_iq_signal;
    case 'wideband_communication' 
        type = 'BPSK';% QPSK BPSK SCFDE
        yunsdr_init.samp=30.72e6;
        yunsdr_init.bw=20e6;
        tx_info = tx_wideband_communication(type);
        txdata = tx_info.base_iq_signal;
end
yunsdr_init.freq=93e6;            % tx LO freq 75e6~6000e6本地载波147.75-148.55  145.5-146.3    147.5-148.3  146.25-146.635  
yunsdr_init.tx_att=0;            % tx att 0~41.95e3 mdB发端衰减，控制发射频率
yunsdr_init.tx_chan=hex2dec('1');   % mask of txch,1,2,4,8通道
yunsdr_init.totalch=2;              % Y230 2ch total
ret=send_to_yunsdr(txdata,yunsdr_init);