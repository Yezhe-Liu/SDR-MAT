function rx_info = ask4_rx_func(rxdata)
rx_info = struct( 'training_seq', [], ... % have no use
                  'len_preamble', 64, ...
                  'corr_peak_thresh', 0.625, ...
                  'len_signal', 12, ...
                  'check_bit', [1; 0; 1; 0], ...
                  'samps_per_symb', 32, ...
                  'base_iq_signal',[], ...
                  'preamble_corr', [], ...
                  'rx_bits_len', [], ...
                  'rx_data_period', [], ...
                  'envelope', [], ...
                  'msg_str', []);
c1=max(max([abs(real(rxdata)),abs(imag(rxdata))]));
rxdata_norm = rxdata./c1;

receive_sig=abs(rxdata_norm);

for i=1:length(receive_sig)
    if(receive_sig(i)>0.8);
        ans(i)=3;
    elseif(receive_sig(i)>0.5 & receive_sig(i)<0.8)
        ans(i)=2;
    elseif (receive_sig(i)>0.2 & receive_sig(i)<0.5)
        ans(i)=1;
    else
        ans(i)=0;
    end
end

%-----ÿ��20�����ȡһ������Ϊ����ź�-----%
re=ans(4:20:end);
%-----��ӳ��-----%
%-----3-->11
%-----2-->10
%-----1-->01
%-----0-->00
re2=[];
demod_data=[];
for i=1:length(re)
    if re(i)==3;
        re2=[1 1];
    elseif re(i)==2
        re2=[1 0];
    elseif re(i)==1
        re2=[0 1];
    else
        re2=[0 0];
    end
    demod_data=[demod_data re2];
end
figure(1);clf;
subplot(311);
plot(real(rxdata));
hold on;
plot(imag(rxdata));
title('���ն˻���ԭʼ�ź�');
subplot(312);
plot(receive_sig);
grid on;
ylim([-1.5 1.5]);
title('����첨�о��ź�');
subplot(313);
plot(ans);
ylim([0 1.5]);
title('�����о��ź�');
rx_info.msg_str=demod_data;
end

