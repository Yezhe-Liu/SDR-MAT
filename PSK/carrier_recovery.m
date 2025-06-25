function [Sig_out, Sin_detect] = carrier_recovery(signal)


K_1 = 0.161419112825058;
K_2 = 9.926059430653343e-04;

%   ËøÏà»·Â·
N_length=length(signal);

Sig_in = signal;                   
Sig_out = [1 zeros(1,N_length)];

Sig_diff = zeros(1,N_length);
Sin_detect = zeros(1,N_length);

Scale1_part = zeros(1,N_length);
Integral1_part = zeros(1,N_length+1);
Loop_filter1 = zeros(1,N_length); 

Scale2_part = zeros(1,N_length);
Integral2_part = zeros(1,N_length+1);
Loop_filter2 = zeros(1,N_length); 
% delta_offset = zeros(1,N_length); 

NCO = zeros(1,N_length+1);

for i_th = 1:N_length
    Sig_diff(i_th) = Sig_in(i_th)*Sig_out(i_th);
    Sin_detect(i_th) = real(Sig_diff(i_th))*imag(Sig_diff(i_th));
    
    Scale1_part(i_th) = K_1*Sin_detect(i_th);
    Integral1_part(i_th+1) = Integral1_part(i_th)+K_2*Sin_detect(i_th);
    Loop_filter1(i_th) = Scale1_part(i_th)+Integral1_part(i_th+1);
    
    Scale2_part(i_th) = K_1*Loop_filter1(i_th);
    Integral2_part(i_th+1) = Integral2_part(i_th)+K_2*Loop_filter1(i_th);
    Loop_filter2(i_th) = Scale2_part(i_th)+Integral2_part(i_th+1);
  
    
    NCO(i_th+1) = Loop_filter2(i_th)+NCO(i_th);
    
    Sig_out(i_th+1) = exp(-j*NCO(i_th+1));
%     delta_offset(i_th) = 2*pi/F_sample*(i_th-1) + 0-NCO(i_th);
end

end

