function rx_info = rx_narrowband_communication(type, base_iq_signal)
switch type
    case 'ASK'
        addpath ASK
        rx_info = ask2_rx_func(base_iq_signal(:,1));
    case 'FSK'
        addpath FSK
        rx_info = fsk2_rx_func(base_iq_signal(:,1));
    case 'PSK'
        addpath PSK
        rx_info = psk2_rx_func(base_iq_signal(:,1));
    case '4ASK'
        addpath 4ASK
        rx_info = ask4_rx_func(base_iq_signal(:,1));
    case 'GSM'
        addpath GSM\receiver_matlab
        rx_info = gsm_rx_func(base_iq_signal(:,1));
    case 'CPFSK'
        addpath source_code\narrowband_communication\CPFSK
        rx_info = cpfsk_rx_func(base_iq_signal(:,1));
    case 'AM'
        addpath AM
        rx_info = am_rx_func(base_iq_signal(:,1));
    case 'FM'
        addpath FM
        rx_info = fm_rx_func(base_iq_signal(:,1));
end
end
