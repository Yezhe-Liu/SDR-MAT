function tx_info = tx_narrowband_communication(type)
switch type
    case 'ASK'
        addpath ASK
        tx_info = ask2_tx_func();
    case 'FSK'
        addpath FSK
        tx_info = fsk2_tx_func();
     case 'PSK'
        addpath PSK
        tx_info = psk2_tx_func();  
    case '4ASK'
        addpath 4ASK
        tx_info = ask4_tx_func();
       case 'GSM'
        addpath GSM\transmitter_matlab
        tx_info = gsm_tx_func();     
     case 'CPFSK'
        addpath CPFSK
        tx_info = cpfsk_tx_func();
    case 'AM'
        addpath AM
        tx_info = am_tx_func();
    case 'FM'
        addpath FM
        tx_info = fm_tx_func();

end

