function [Bibit, Stateo, PeakPe]=DEQ(Peak, Statei)
%DEQ      To demodulate the QPSK modulated signal
%Peak	  Peak value of BMF or FWT 
%Statei   Initial phase for reference by differential demodulation
%Bibit    2 bits data of demodulation output
%Stateo   Phase output for reference by other demodulation modes
%PeakPe   Result of rotating "Peak" to a certain quadrant range

%calculate the output state
d0 = ((real(Peak) - imag(Peak)) < 0);
d1 = ((real(Peak) + imag(Peak)) < 0);
d0_1 = xor(d0, d1);
Stateo = d1*2 + d0_1;
%decoding 
diff = mod(Stateo-Statei, 4);
Bibit(1) = floor(diff/2);
Bibit(2) = xor(mod(diff,2), Bibit(1));
%Transform the angle of "Peak" to the range of [-pi/4, pi/4] 
switch Stateo
case 0
    PeakPe = Peak;
case 1
    PeakPe = Peak * (-j);
case 2
    PeakPe = -Peak;
case 3
    PeakPe = Peak * (j);
end

