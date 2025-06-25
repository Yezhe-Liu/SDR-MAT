tTotal=clock;

% THERE HAS NOT BEEN ANY ERRORS, YET...
%
B_ERRS=0;

% gsm_set must be run prior to any simulations, since it does setup
% of values needed for operation of the package.
gsm_set;

% get data for a burst
%
tx_data = data_gen(INIT_L);

% this is all that is needed for modulating a gsm bust, in the format
% used in gsmsim. the call includes generation and modulattion of data.
%
[ burst , I , Q ] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING);

% at this point we run the channel simulation. note, that the channel
% includes transmitter fornt-end, and receiver front-end. the channel
% selection is by nature included in the receiver front-end.
% the channel simulator included in the gsmsim package only add
% noise, and should _not_ be used for scientific purposes.
%
%r=channel_simulator(I,Q,OSR);
tx_data = I + j*Q;

figure(1);
subplot(121);
plot(real(tx_data));
hold on;
plot(imag(tx_data));
ylim([-1.5 1.5]);
subplot(122);
pwelch(tx_data, [],[],[],'centered','psd');