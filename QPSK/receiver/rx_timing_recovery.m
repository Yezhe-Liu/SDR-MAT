function [sig_down_samp, rx_info] = rx_timing_recovery(rx_signal_fine, rx_info)

RollOff = rx_info.RollOff; 
NumOfTsSingleSide = rx_info.NumOfTsSingleSide; 
UpSampleRate = rx_info.UpSampleRate;

fir = rcosfir(RollOff, NumOfTsSingleSide, UpSampleRate, 1, 'sqrt');

%% 2nd_LOOP_Filter参数
C1 = 1/2^12; 
C2 = C1^2/2;

sig_fir = conv(rx_signal_fine, fir);
% scale = max([max(real(sig_fir)) max(imag(sig_fir))]);
% sig_fir = sig_fir./scale;

%% NCO-LOOP_Filter-参数
NCO_reg = zeros(1,length(sig_fir)-120);
NCO_cnt = 0;
W = 0.1*ones(1,length(sig_fir)-120);
sig_down_samp = zeros(1,length(sig_fir)-120);
y_mid = zeros(1,length(sig_fir)-120);
ted_err = zeros(1,length(sig_fir)-120);
uk_vec = zeros(1,length(sig_fir)-120);

%% Closed_Loop_Simulation
for n = 1:length(sig_fir)-120
    NCO_reg(n+1) = NCO_reg(n)-W(n);
    if( NCO_reg(n+1)<0 )
        NCO_reg(n+1) = NCO_reg(n+1)+1;
        mk = n+60;
        %uk = NCO_reg(n)*UpSampleRate;
        uk = NCO_reg(n)/W(n);
        % Farrow滤波器
        c_2 = 1/6*uk^3-1/6*uk; 
        c_1 = -1/2*uk^3+1/2*uk^2+uk; 
        c_0 = 1/2*uk^3-uk^2-1/2*uk+1; 
        c1 = -1/6*uk^3+1/2*uk^2-1/3*uk; 
        d2 = sig_fir(mk+2); 
        d1 = sig_fir(mk+1); 
        d0 = sig_fir(mk); 
        d_1 = sig_fir(mk-1); 
        %
        iData = c_2*d2+c_1*d1+c_0*d0+c1*d_1; %最佳采样点输出
        %
        NCO_cnt = NCO_cnt+1;
        mk_vec(NCO_cnt) = mk;
        sig_down_samp(NCO_cnt) = iData; %  采样点有固定频差[可通过星座图观察]，需要 PLL 消除频差 df
        
        % 两最佳采样点之间的中间点
        mk_mid = fix(mk+uk-0.5*(1/W(n))); 
        uk_mid = mk+uk-0.5*(1/W(n))-mk_mid;
        uk_vec(NCO_cnt) = uk;
        mk = mk_mid;
        uk = uk_mid;
        %
        c_2 = 1/6*uk^3-1/6*uk; 
        c_1 = -1/2*uk^3+1/2*uk^2+uk; 
        c_0 = 1/2*uk^3-uk^2-1/2*uk+1; 
        c1 = -1/6*uk^3+1/2*uk^2-1/3*uk; 
        d2 = sig_fir(mk+2); 
        d1 = sig_fir(mk+1); 
        d0 = sig_fir(mk); 
        d_1 = sig_fir(mk-1); 
        %
        iData=c_2*d2+c_1*d1+c_0*d0+c1*d_1;
        %
        y_mid(NCO_cnt) = iData;
        %定时误差检测
        if(NCO_cnt>1)
            %ted = y_mid(NCO_cnt)*(y_optimal(NCO_cnt)-y_optimal(NCO_cnt-1));
            y = [sig_down_samp(NCO_cnt-1) y_mid(NCO_cnt) sig_down_samp(NCO_cnt)];
            y_Re = real(y);
            %y_Im = imag(y);
            ted = y_Re(2)*(y_Re(3)-y_Re(1));
            ted_err(NCO_cnt) = ted;
            %环路滤波器
            W(n+1) = W(n)+C1*(ted_err(NCO_cnt)-ted_err(NCO_cnt-1))+C2*ted_err(NCO_cnt);
        else
            %ted = y_mid(NCO_cnt)*(y_optimal(NCO_cnt)-0);
            y = [0 y_mid(NCO_cnt) sig_down_samp(NCO_cnt)];
            y_Re = real(y);
            %y_Im = imag(y);
            ted = y_Re(2)*(y_Re(3)-y_Re(1));
            ted_err(NCO_cnt) = ted;
            %环路滤波器
            W(n+1) = W(n)+C1*(ted_err(NCO_cnt)-0)+C2*ted_err(NCO_cnt);
        end
    else
        W(n+1) = W(n);
    end
end

rx_info.uk_vec = uk_vec;


end

