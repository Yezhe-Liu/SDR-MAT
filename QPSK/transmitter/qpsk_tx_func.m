function tx_info = qpsk_tx_func()

tx_info = struct( 'len_preamble', 64, ...
                  'len_subframe', 120, ...             % bit length
                  'SFD', [0 0 0 0 0 1 0 1 1 1 0 0 1 1 1 1], ...
                  'scramble_int', [1 0 0 1 0 1 0 1 0 0 0 0 0 0 0], ...
                  'InitState', 0, ...
                  'RollOff', 0.5, ...
                  'NumOfTsSingleSide', 3, ...
                  'UpSampleRate', 10, ...
                  'base_iq_signal',[]);

msgStr = msgGet();
msg_bits = str_to_bits(msgStr);

tx_bits = [msg_bits(1:2400) tx_info.SFD msg_bits(2401:end)];

%% scramble
scramble_bits = randomizer(tx_info.scramble_int, tx_bits);

mod_symbols = mod_dqpsk(tx_info.InitState, scramble_bits);

%% srrc
% 平方根升余弦函数，即发送、接受滤波器
fir = rcosfir(tx_info.RollOff, tx_info.NumOfTsSingleSide, tx_info.UpSampleRate, 1, 'sqrt'); 
%过采样
symbol_upsample = upsample(mod_symbols, tx_info.UpSampleRate);
%经发送滤波器（成形滤波器-平方根升余弦函数），消除ISI
base_iq_signal = conv(symbol_upsample, fir); 

preamble = tx_gen_preamble(tx_info.len_preamble).*0.3;

tx_info.base_iq_signal = [preamble; preamble; base_iq_signal.'];

end

