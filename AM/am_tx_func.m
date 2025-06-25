function tx_info = am_tx_func()

tx_info = struct( 'training_seq', [], ... % have no use
                  'preamble', [], ...     % have no preamble
                  'audio', 'test_audio.wav', ... %空空如也.mp3    test_audio.wav
                  'Amp', 1, ...
                  'fc', 20e3, ...
                  'fs', 100e3, ...
                  'base_iq_signal', []);
              
%读入语音信号
[sig_audio, samp_freq] = audioread(tx_info.audio);      
fprintf('audio_samp_freq = %d Hz\n', samp_freq);
sig_am = am_mod(sig_audio, tx_info.Amp, tx_info.fc, tx_info.fs);
%if length(sig_am)>122880      %122880
%    sig_am(122881:end)=[];
%end
tx_info.base_iq_signal = sig_am.';

figure(1);clf;
subplot(121);
plot(real(tx_info.base_iq_signal));
hold on;
plot(imag(tx_info.base_iq_signal));
grid on;
ylim([-2.0 2.0]);
subplot(122);
pwelch(tx_info.base_iq_signal, [], [], [], 'centered', 'psd');

end

