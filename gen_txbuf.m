function [tx_buf,length_tx,channel]=gen_txbuf(txdata)
length_tx=size(txdata,1);
tx_chb=ones(size(txdata,2),1).';
for i=1:size(txdata,2)
  c1=max(max([abs(real(txdata(:,i))),abs(imag(txdata(:,i)))]));
  if(c1>0)
    index=2000/c1;
  else
    index=0;
    tx_chb(i)=0;
  end
  txdata1(:,i)=round(txdata(:,i).*index)*16;
end
channel=bi2de(tx_chb,'right-msb');
txdata_s=txdata1(:);
txdatai=real(txdata_s);
txdataq=imag(txdata_s);
txdatam=zeros(length(txdatai)*2,1);
txdatam(1:2:end)=txdatai;
txdatam(2:2:end)=txdataq;
txdatamu=txdatam+(txdatam<0)*65536;
tx_buf = libpointer('voidPtrPtr');
tx_buf.Value = libpointer('int16Ptr', txdatamu);
end
