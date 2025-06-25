function tx_info = fsk2_tx_func()

tx_info = struct( 'training_seq', [], ... % have no use
                  'len_preamble', 64, ...
                  'preamble', [], ...
                  'len_signal', 12, ...
                  'check_bit', [1; 0; 1; 0], ...
                  'f1', 200, ...
                  'f2', 400, ...
                  'samps_per_symb', 1103, ...
                  'msg_str', [], ...
                  'base_iq_signal', []);

preamble = tx_gen_preamble(tx_info.len_preamble);
tx_info.preamble = preamble;
%Prompt for string to transmit
% prompt = 'Enter a string to tx: ';
msg_str = 'hello world';%input(prompt, 's');
tx_info.msg_str = msg_str;
msg_bits = str_to_bits(msg_str);
% 16-bit signal, including 4 check bits
signal = zeros(1, tx_info.len_signal+length(tx_info.check_bit));
signal(1:tx_info.len_signal) = de2bi(length(msg_bits),tx_info.len_signal, 'right-msb');
signal(tx_info.len_signal+1:end) = tx_info.check_bit;

sig_fsk = fsk_mod(signal, msg_bits, tx_info.f1, tx_info.f2, tx_info.samps_per_symb);
base_iq_signal = [preamble; preamble; sig_fsk];
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

