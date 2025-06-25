function rx_info = rx_wideband_communication(type, base_iq_signal, samp_rate)
switch type
    case 'QPSK'
        addpath QPSK\receiver
        rx_info = qpsk_rx_func(base_iq_signal(:,1), samp_rate);
    case 'BPSK'
        addpath BPSK\receiver
        rx_info = bpsk_rx_func(base_iq_signal(:,1), samp_rate);
    case 'SCFDE'
        addpath SCFDE\receiver
        rx_info = scfde_rx_func(base_iq_signal(:,1));
end
end
