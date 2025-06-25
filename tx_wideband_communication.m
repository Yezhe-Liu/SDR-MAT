function tx_info = tx_wideband_communication(type)
switch type
    case 'QPSK'
        addpath QPSK\transmitter
        tx_info = qpsk_tx_func();
    case 'BPSK'
        addpath BPSK\transmitter
        tx_info = bpsk_tx_func();
    case 'SCFDE'
        addpath SCFDE\transmitter
        tx_info = scfde_tx_func();
end

