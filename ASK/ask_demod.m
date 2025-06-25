function [bits, envelope] = ask_demod(iq_signal, samps_per_symb)

envelope = abs(iq_signal) > 0.5;
% demod
bits = envelope(samps_per_symb/2:samps_per_symb:end);

end

