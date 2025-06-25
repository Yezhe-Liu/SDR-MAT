function tx_info = gsm_tx_func()

% gsm_set must be run prior to any simulations, since it does setup
% of values needed for operation of the package.
gsm_set;

% get data for a burst
%
tx_bits = data_gen(INIT_L);
save('tx_bits.mat');
% this is all that is needed for modulating a gsm bust, in the format
% used in gsmsim. the call includes generation and modulattion of data.
%
[ burst , I , Q ] = gsm_mod(Tb,OSR,BT,tx_bits,TRAINING);

% at this point we run the channel simulation. note, that the channel
% includes transmitter fornt-end, and receiver front-end. the channel
% selection is by nature included in the receiver front-end.
% the channel simulator included in the gsmsim package only add
% noise, and should _not_ be used for scientific purposes.
%
%r=channel_simulator(I,Q,OSR);
base_iq_signal = I + j*Q;
preamble = tx_gen_preamble(64);
tx_info.base_iq_signal = [preamble; preamble;base_iq_signal.'];
figure(1);
subplot(121);
plot(real(tx_info.base_iq_signal));
hold on;
plot(imag(tx_info.base_iq_signal));
ylim([-1.5 1.5]);
subplot(122);
pwelch(tx_info.base_iq_signal, [],[],[],'centered','psd');

end

