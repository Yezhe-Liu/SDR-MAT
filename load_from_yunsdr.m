function [rxdata,sample_rate]= load_from_yunsdr(yunsdr_init)
if not(libisloaded('libyunsdr_ss'))
    [notfound,warnings] = loadlibrary('libyunsdr_ss','yunsdr_api_ss.h');
end
dptr = libpointer('yunsdr_device_descriptor');
devstring = libpointer('cstring');
devstring.Value = 'usb3:0,nsamples_recv_frame:7680';
dptr = calllib('libyunsdr_ss', 'yunsdr_open_device', devstring);
if isNull(dptr)
    disp 'open yunsdr failed!';
    return;
end
value32=libpointer('uint32Ptr',0);
value64=libpointer('uint64Ptr',0);
disp('Open all link sucess');
%%  Configure RF RX:
ret=calllib('libyunsdr_ss','yunsdr_set_tx_sampling_freq',dptr,0,uint32(yunsdr_init.samp));
for i=0:0
    ret=calllib('libyunsdr_ss','yunsdr_set_rx_lo_freq',dptr,i,uint64(yunsdr_init.freq));
    ret=calllib('libyunsdr_ss','yunsdr_set_rx_rf_bandwidth',dptr,0,yunsdr_init.bw);% 200e3~56e6
    ret=calllib('libyunsdr_ss','yunsdr_set_rx1_rf_gain',dptr,i,uint32(yunsdr_init.rx_gain));
    ret=calllib('libyunsdr_ss','yunsdr_set_rx2_rf_gain',dptr,i,uint32(yunsdr_init.rx_gain));
end
ret=calllib('libyunsdr_ss','yunsdr_get_tx_sampling_freq',dptr,0,value32);
sample_rate=double(value32.Value);
ret=calllib('libyunsdr_ss','yunsdr_get_rx_lo_freq',dptr,0,value64);
rx_lo_freq=double(value64.Value);
disp(['rx_lo_freq=',num2str(rx_lo_freq)]);
%% set timpstamp start
ret=calllib('libyunsdr_ss','yunsdr_enable_timestamp',dptr,0,0);
ret=calllib('libyunsdr_ss','yunsdr_enable_timestamp',dptr,0,1);pause(3);
%% receive data
delete('*.dat');
[rxdata,rx_time]=gen_rxbuf(dptr,614400,yunsdr_init.rx_chan,0);
ret = calllib('libyunsdr_ss', 'yunsdr_close_device', dptr);
disp([num2str(rx_time)]);
