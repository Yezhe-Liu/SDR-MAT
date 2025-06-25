function rx_info = gsm_rx_func(rxdata)

gsm_set;
Lh = 3;
[ SYMBOLS , PREVIOUS , NEXT , START , STOPS ] = viterbi_init(Lh);
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
rx_info.base_iq_signal = rxdata;
[ret, thres_idx, preamble_corr] =rx_search_packet(rx_info.base_iq_signal, rx_info.len_preamble, rx_info.corr_peak_thresh);
if ret < 0
    msgbox('Could not find preamble!', 'Error','error');
    return;
end
rx_info.preamble_corr = preamble_corr;
rx_sig_fine = rxdata(thres_idx:end);
rx_preamble = rx_sig_fine(1:rx_info.len_preamble*2);

%Normalize signal to [-1, 1]
scale = max([max(real(rx_preamble)) max(imag(rx_preamble))]);
rx_sig_fine = rx_sig_fine./scale;

rx_sig_fine = rx_sig_fine(rx_info.len_preamble*2+1:rx_info.len_preamble*2+600).';
%Normalize signal to [-1, 1]

[Y, Rhh] = mafi(rx_sig_fine,Lh,T_SEQ,OSR);

% having prepared the precalculatable part of the viterbi
% algorithm, it is called passing the obtained information along with
% the received signal, and the estimated autocorrelation function.
%
rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);

% run the demux
%
rx_data=DeMUX(rx_burst);
load('tx_bits.mat')
error = biterr(tx_bits,rx_data);
fprintf('biterr = %d\n', error);
end

