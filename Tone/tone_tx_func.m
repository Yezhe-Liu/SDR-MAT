function txdata = tone_tx_func(samplerate)
freq=32;
a=cos(2*pi/freq*[0:freq-1].');
b=sin(2*pi/freq*[0:freq-1].');
c=a+1i*b;
txdata=repmat(c,samplerate/1000/freq,1);

pwelch(txdata,[],[],[],samplerate,'centered','psd');

end

