function [ret, thres_idx, preamble_corr]=rx_search_packet(rx_signal, len_preamble, corr_peak_thresh)
%% load local long training
preamble = tx_gen_preamble(len_preamble);

L=len_preamble;
for j=1:length(rx_signal)-L*2
    rx_cross_corr(j) = abs(sum(rx_signal(j:j+L-1).*conj(preamble)));
    rx_self_corr(j) = sum(rx_signal(j:j+L-1).*conj(rx_signal(j:j+L-1))).^0.5;
    rx_cross_ratio(j)=rx_cross_corr(j)./rx_self_corr(j)./sum(abs(preamble)).^0.5;
end
index=find(rx_cross_ratio>corr_peak_thresh);

if length(index)>=2
    if index(2)<index(1)+L && index(2)>=index(1)+8
        thres_idx=index(2);
    else
        thres_idx=index(1);
    end
    preamble_corr = rx_cross_ratio(1:thres_idx+L).';
    ret = 0;
    return;
else
    thres_idx=-1;
    preamble_corr = [];
    ret = -1;
    return;
end


