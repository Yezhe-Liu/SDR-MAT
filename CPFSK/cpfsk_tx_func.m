function tx_info = cpfsk_tx_func()

%32 bit training sequence
%hex: AA, AA, AA, AA
%Note: In order for the preamble waveform not to be messed up, the last
%sample of the modulated training sequence MUST be 1 + 0j
%32-bit preamble - hex: 2E, 69, 2C, F0
tx_info = struct( 'training_seq', ['10101010';
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
             
%Prompt for string to transmit
% prompt = 'Enter a string to tx: ';
msg_str = 'hello world';%input(prompt, 's');
tx_info.msg_str = msg_str;
% 16-bit signal
signal = reshape(num2str(de2bi(length(msg_str),16,'left-msb')'), 8, 2)';
%Convert to bit matrix
msg_bits = dec2bin(uint8(msg_str), 8);
%Make FSK signal
sig_cpfsk = fsk_transmit(tx_info.training_seq, tx_info.preamble, signal, msg_bits, tx_info.samps_per_symb, tx_info.h);
%Add some flat output to the front and back of the signal
sig_cpfsk(tx_info.null_amt+1:length(sig_cpfsk)+tx_info.null_amt) = sig_cpfsk;
sig_cpfsk(1:tx_info.null_amt) = 0 + 0j;
sig_cpfsk(length(sig_cpfsk)+1:length(sig_cpfsk)+tx_info.null_amt) = 0 + 0j;
base_iq_signal = sig_cpfsk.';
tx_info.base_iq_signal = base_iq_signal;

figure(1);clf;
subplot(121);
plot(real(base_iq_signal));
hold on;
plot(imag(base_iq_signal));
grid on;
ylim([-1.5 1.5]);
subplot(122);
pwelch(base_iq_signal, [], [], [], 'centered', 'psd');

end

