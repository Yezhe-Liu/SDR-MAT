function [Bit, Stateo, PeakPe]=DEB(Peak, Statei)
%DEB      To demodulate the BPSK modulated signal
%Peak	  Peak value of BMF带通滤波器 or FWT傅里叶变换-----之后的信号峰值 
%Statei   Initial phase for reference by differential demodulation初始相位
%Bibit    1 bit data of demodulation output
%Stateo   Phase output for reference by other demodulation modes
%PeakPe   Result of rotating "Peak" to a certain quadrant range

Stateo = 2*(real(Peak) < 0); %The output state
Bit = mod((Stateo-Statei)/2, 2); %Decoding
%Transform the angle of "Peak" to the range of [-pi/2, pi/2] 
switch Stateo
case 0
    PeakPe = Peak;
case 2
    PeakPe = -Peak;
end

