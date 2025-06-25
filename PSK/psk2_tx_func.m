function tx_info = psk2_tx_func()

tx_info = struct( 'training_seq', [], ... % have no use
                  'len_preamble', 64, ...
                  'preamble', [], ...
                  'check_phase', [1 0 1 0], ...
                  'len_signal', 12, ...
                  'check_bit', [1 0 1 0], ...
                  'samps_per_symb', 1000, ...
                  'init_phase', 0, ...
                  'msg_str', [], ...
                  'base_iq_signal', []);

preamble = tx_gen_preamble(tx_info.len_preamble);
tx_info.preamble = preamble;
%Prompt for string to transmit
% prompt = 'Enter a string to tx: ';
msg_str = 'hello BYR';%input(prompt, 's');
tx_info.msg_str = msg_str;
msg_bits = str_to_bits(msg_str);
% 20-bit signal, including 4 sfd bits and 4 check bits
signal = zeros(1, length(tx_info.check_phase)+tx_info.len_signal+length(tx_info.check_bit));
signal(1:length(tx_info.check_phase)) = tx_info.check_phase;
signal(length(tx_info.check_phase)+1:length(tx_info.check_phase)+tx_info.len_signal) = de2bi(length(msg_bits),tx_info.len_signal, 'right-msb');
signal(length(tx_info.check_phase)+tx_info.len_signal+1:end) = tx_info.check_bit;
signal = [1 1 1 1 signal];
sig_psk = psk_mod(signal, msg_bits, tx_info.samps_per_symb, tx_info.init_phase);
base_iq_signal = [preamble; preamble; sig_psk];
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

