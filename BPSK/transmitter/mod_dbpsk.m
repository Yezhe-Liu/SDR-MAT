function mod_symbols = mod_dbpsk(state,datain)

datar(1)=xor(state,datain(1));%计算差值
for i=2:length(datain)
    datar(i)=xor(datar(i-1),datain(i));
end

mod_symbols=double(~datar);%取反



for i=1:length(datain);
    state=state+datain(i)*pi;
    b=exp(1i*state);
    mod_symbols(i)=b;
    state=mod(state,2*pi);
end

mod_symbols = mod_symbols.*exp(1i*pi/4);
end