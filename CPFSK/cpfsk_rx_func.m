function rx_info = cpfsk_rx_func(rxdata)

%32 bit training sequence
%hex: AA, AA, AA, AA
%Note: In order for the preamble waveform not to be messed up, the last
%sample of the modulated training sequence MUST be 1 + 0j
%32-bit preamble - hex: 2E, 69, 2C, F0
config_info = struct( 'training_seq', ['10101010';
                                   '10101010';
                                   '10101010';
                                   '10101010'], ... 
                  'preamble',     ['00101110'; ...
                                   '01101001'; ...
                                   '00101100'; ...
                                   '11110000'], ...
                  'Fs',            2e6, ... %Sample rate of 2 Msps (500ns sample period)
                  'samps_per_symb',8, ...   %Samples per symbol
                  'h', pi/2, ...            %Phase modulation index (phase deviation per symbol)
                  'dec_factor',    2, ...   %Amount to decimate by when performing correlation with preamble
                  'null_amt', 200, ...      %Amount of flat samples (0+0j) to add to the beginning/end of tx signal
                  'msg_str', [], ...
                  'base_iq_signal', []);

c1=max([abs(real(rxdata.')),abs(imag(rxdata.'))]);
rx_sig=rxdata ./c1;
rx_sig = rx_sig.';
%%---------------------RECEIVE---------------------------
%clamp signal to [-1.0, 1.0]
rx_sig_i = real(rx_sig);
rx_sig_q = imag(rx_sig);
rx_sig_i(rx_sig_i > 1.0) = 1.0;
rx_sig_i(rx_sig_i < -1.0) = -1.0;
rx_sig_q(rx_sig_q > 1.0) = 1.0;
rx_sig_q(rx_sig_q < -1.0) = -1.0;
rx_sig = rx_sig_i + 1j*rx_sig_q;

%Get the modulated IQ waveform for the preamble
preamble_waveform = fsk_mod(config_info.preamble, config_info.samps_per_symb, config_info.h, 0);
%Filter/Normalize/Detect/Demodulate FSK signal
[rx_bits, rx_info] = fsk_receive(preamble_waveform, rx_sig, config_info.dec_factor, config_info.samps_per_symb, config_info.h);
rx_info.base_iq_signal = rxdata;
rx_info.rx_bits = rx_bits;
rx_display(rx_info, config_info);
end

