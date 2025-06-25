function ret=send_to_yunsdr(txd,yunsdr_init)
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
%%  Configure RF TX:
ret=calllib('libyunsdr_ss','yunsdr_set_tx_sampling_freq',dptr,0,uint32(yunsdr_init.samp));
for i=0:0
    ret=calllib('libyunsdr_ss','yunsdr_set_tx_lo_freq',dptr,i,uint64(yunsdr_init.freq));
    ret=calllib('libyunsdr_ss','yunsdr_set_tx_rf_bandwidth',dptr,0,yunsdr_init.bw);% 200e3~56e6
    ret=calllib('libyunsdr_ss','yunsdr_set_tx1_attenuation',dptr,i,uint32(yunsdr_init.tx_att));
    ret=calllib('libyunsdr_ss','yunsdr_set_tx2_attenuation',dptr,i,uint32(yunsdr_init.tx_att));
end
ret=calllib('libyunsdr_ss','yunsdr_get_tx_sampling_freq',dptr,0,value32);
sample_rate=double(value32.Value);

pause(0.1);
%% set timpstamp start
ret=calllib('libyunsdr_ss','yunsdr_tx_cyclic_enable',dptr,0,0);% reset txcyclic
pause(0.1);
ret=calllib('libyunsdr_ss','yunsdr_enable_timestamp',dptr,0,0);
ret=calllib('libyunsdr_ss','yunsdr_enable_timestamp',dptr,0,1);
%% generate txbuf
txdata=repmat(txd,1,yunsdr_init.totalch);
[tx_buf,length_tx,~]=gen_txbuf(txdata);
%% send data in txcyclic mode
ret=calllib('libyunsdr_ss','yunsdr_tx_cyclic_enable',dptr,0,0);% reset txcyclic
ret=calllib('libyunsdr_ss','yunsdr_tx_cyclic_enable',dptr,0,1);
ret=calllib('libyunsdr_ss','yunsdr_read_timestamp',dptr,0,value64);
ts3=value64.Value+sample_rate;
nwrite = calllib('libyunsdr_ss', 'yunsdr_write_samples_multiport_Matlab',  ...
    dptr, tx_buf, length_tx, yunsdr_init.tx_chan, ts3, 0);
ret=calllib('libyunsdr_ss','yunsdr_tx_cyclic_enable',dptr,0,3);% start txcyclic
if nwrite < 0
    ret='data send to yunsdr fail';
	disp (ret);
    return
else
    ret='data send to yunsdr ok';
    disp(ret);
end
%% close device
ret = calllib('libyunsdr_ss', 'yunsdr_close_device', dptr);