function [rxdata,timerx]=gen_rxbuf(dptr,rxlength,rxch,time_rx)
% rx_buf = libpointer('voidPtrPtr');
rx_buf = libpointer('voidPtr');
timestamp = libpointer('uint64Ptr', time_rx);
nread = calllib('libyunsdr_ss', 'yunsdr_read_samples_multiport_Matlab', dptr, rx_buf, rxlength, rxch, timestamp);
if nread < 0
    disp ('rx error!');
end
rxd1=[];
rx_chb=de2bi(rxch,8);
if(rx_chb(1))
    fid=fopen('rx_iqsamples_int16_channel1.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(2))
    fid=fopen('rx_iqsamples_int16_channel2.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(3))
    fid=fopen('rx_iqsamples_int16_channel3.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(4))
    fid=fopen('rx_iqsamples_int16_channel4.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(5))
    fid=fopen('rx_iqsamples_int16_channel5.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(6))
    fid=fopen('rx_iqsamples_int16_channel6.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(7))
    fid=fopen('rx_iqsamples_int16_channel7.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
if(rx_chb(8))
    fid=fopen('rx_iqsamples_int16_channel8.dat','r');
    B=fread(fid,'int16');
    fclose('all');
    rxd1=[rxd1 B];
end
rxdata=rxd1(1:2:end,:)+1i*rxd1(2:2:end,:);
timerx=timestamp.Value;
% disp(timerx);