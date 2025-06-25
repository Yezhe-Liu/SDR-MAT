function [rx_sig_carrier_sync, rx_info] = rx_carrier_sync(sig_down_samp, rx_info)

%% Loop_Filter ��������
K0 = 1;
Kd = 1;
K = 1;
BL = 10; % ��·����
Wn = 1.2747*BL;
a3 = 1.1;
b3 = 2.4;
T_acc = 1.0e-3; % ��·��������

Threshold = pi/2;

% ��ʱ�м�����洢
temp1 = zeros(1,length(sig_down_samp));
temp2 = zeros(1,length(sig_down_samp));

%% ���໷·
% ��һ����
rx_sig_carrier_sync(1) = sig_down_samp(1);
% ����
% pd(1) = sign(real(rx_sig_carrier_sync(1))).*imag(rx_sig_carrier_sync(1)) - sign(imag(rx_sig_carrier_sync(1))).*real(rx_sig_carrier_sync(1));
pd(1) = (imag(rx_sig_carrier_sync(1))/real(rx_sig_carrier_sync(1)));
if pd(1) > Threshold
    pd(1) = Threshold;
elseif pd(1) < -Threshold
    pd(1) = -Threshold;
end
ud = pd(1)*Kd/K;
temp1(1) = ud*Wn^3*T_acc;
add_1 = 0.5*temp1(1);
temp2(1) = T_acc*(add_1+ud*a3*Wn^2);
add_2 = 0.5*temp2(1);
uf(1) = add_2+ud*b3*Wn;
theta(1) = 0;
% �����ĵ�
for i = 2:length(sig_down_samp)
    rx_sig_carrier_sync(i) = sig_down_samp(i)*exp(-1i*theta(i-1));
    % ����
%     pd(i) = sign(real(rx_sig_carrier_sync(i))).*imag(rx_sig_carrier_sync(i)) - sign(imag(rx_sig_carrier_sync(i))).*real(rx_sig_carrier_sync(i));
    pd(i) = (imag(rx_sig_carrier_sync(i))/real(rx_sig_carrier_sync(i)));
    if pd(i) > Threshold
        pd(i) = Threshold;
    elseif pd(i) < -Threshold
        pd(i) = -Threshold;
    end
    ud = pd(i)*Kd/K;
    temp1(i) = temp1(i-1)+ud*Wn^3*T_acc;
    add_1 = 0.5*(temp1(i)+temp1(i-1));
    temp2(i) = temp2(i-1)+T_acc*(add_1+ud*a3*Wn^2);
    add_2 = 0.5*(temp2(i)+temp2(i-1));
    uf(i) = add_2+ud*b3*Wn;
    theta(i) = theta(i-1)+K0*T_acc*uf(i-1);
end

rx_info.theta = theta;

end

