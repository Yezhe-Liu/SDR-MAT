function [Y, Rhh] = mafi(r,L,T_SEQ,OSR)
%
% MAFI:     This function performes the tasks of channel impulse
%           respons estimation, bit syncronization, matched 
%           filtering and signal sample rate downconversion.
%
% SYNTAX:   [y, Rhh] = mafi(r,Lh,T_SEQ,OSR)
%
% INPUT:    r     Complex baseband representation of the received
%                 GMSK modulated signal
% 	    Lh    The desired length of the matched filter impulse
%                 response measured in bit time durations
% 	    T_SEQ A MSK-modulated representation of the 26 bits long
%                 training sequence used in the transmitted burst, 
%                 i.e. the training sequence used in the generation of r
%           OSR   Oversampling ratio, defined as f_s/r_b.
%
% OUTPUT:   Y     Complex baseband representation of the matched 
%                 filtered and down converted received signal
%
%           Rhh   Autocorrelation of the estimated channel impulse 
%                 response. The format is a Lh+1 unit long column vector 
%                 starting with Rhh[0], and ending with Rhh[Lh]. 
%                 Complex valued.
%
% SUB_FUNC: None
%
% WARNINGS: The channel estimation is based on the 16 most central 
%           bits of the training sequence only
%
% TEST(S):  Tested manually through test script mf_ill.m
%
% AUTOR:    Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: mafi.m,v 1.1 1998/10/01 10:20:21 hmi Exp $

DEBUG=1;

% PICK CENTRAL 16 BITS [ B | C | A ] AS COMPROMISE
% AND PERFORM COMPLEX CONJUGATION
%
T16 = conj(T_SEQ(6:21));

% extract relevant part of the received signal. using
% guard times as guidelines implies extracting the part 
% starting approximately at 10 TB's before the 16 most 
% central training sequence bits and ending approximately
% 10 tb's after. assume that bursts tend to be centered in
% a sample stream.
%
GUARD = 10;
center_r=round(length(r)/2);
start_sub=center_r-(GUARD+8)*OSR;
end_sub=center_r+(GUARD+8)*OSR;

% you may want to enable this for special debuggnig
%
%start_sub=1;
%end_sub=length(r);

r_sub = r(start_sub:end_sub);

if DEBUG,
  % debugging, verifies that we pick the right part out
  % 
  count=1:length(r);
  figure
  plot(count,real(r));
  plug=start_sub:end_sub;
  hold on;
  plot(plug,real(r_sub),'r')
  hold off;
  title('Real part of r and r_sub (red)');
  %pause;
end

% prepare vector for data processing
%
chan_est = zeros(1,length(r_sub)-OSR*16);

% estimate channel impulse response using only every
% OSR'th sample in the received signal
%
for n = 1:length(chan_est),
  chan_est(n)=r_sub(n:OSR:n+15*OSR)*T16.';
end

if DEBUG,
  % debugging, provides a plot of the estimated impulse
  % response for the user to gaze at
  figure;
  plot(abs(chan_est));
  title('The absoulte value of the correlation');
  %pause;
end

chan_est = chan_est./16;

% extracting estimated impuls respons by searching for maximum
% power using a window of length osr*(l+1)
%
WL = OSR*(L+1);

search = abs(chan_est).^2;
for n = 1:(length(search)-(WL-1)),
  power_est(n) = sum(search(n:n+WL-1));
end

if DEBUG,
  % DEBUGGING, SHOWS THE POWER ESTIMATE
  figure;
  plot(power_est);
  title('The window powers');
  %pause;
end

% searching for maximum value power window and selecting the
% corresponding estimated matched filter tap coefficiens. also,
% the syncronization sample corresponding to the first sample
% in the t16 training sequence is estimated
%
[peak, sync_w] = max(power_est);
h_est = chan_est(sync_w:sync_w+WL-1);

[peak, sync_h] = max(abs(h_est));
sync_T16 = sync_w + sync_h - 1;

if DEBUG,
  % DEBUGGING, SHOWS THE POWER ESTIMATE
  figure;
  plot(abs(h_est));
  title('Absolute value of extracted impulse response');
  %pause;
end

% we want to use the first sample of the impulseresponse, and the
% corresponding samples of the received signal.
% the variable sync_w should contain the beginning of the used part of
% training sequence, which is 3+57+1+6=67 bits into the burst. that is
% we have that sync_t16 equals first sample in bit number 67.
%
burst_start = ( start_sub + sync_T16 - 1 ) - ( OSR * 66 + 1 ) + 1;

% compensating for the 2 TB delay introduced in the gmsk modulator.
% each bit is streched over a period of 3 tb with its maximum value
% in the last bit period. hence, burst_start is 2 * osr misplaced. 
%
burst_start = burst_start - 2*OSR + 1;

% calculate autocorrelation of channel impulse
% respons. down conversion is carried out at the same
% time
%
R_temp = xcorr(h_est);

pos = (length(R_temp)+1)/2;

Rhh=R_temp(pos:OSR:pos+L*OSR);

% PERFORM THE ACTUAL MATCHED FILTERING
%

m = length(h_est)-1;

% a single zero is inserted in front of r since there is an equal 
% number of samples in r_sub we cannot be totally certain which 
% side of the middle that is chosen thus an extra sample is 
% needed to avoid crossing array bounds.
%
GUARDmf = (GUARD+1)*OSR;
r_extended = [ zeros(1,GUARDmf) r zeros(1,m) zeros(1,GUARDmf)];

% recall that the ' operator in matlab does conjugation
%

for n=1:148,
  aa=GUARDmf+burst_start+(n-1)*OSR;
  bb=GUARDmf+burst_start+(n-1)*OSR+m;
  Y(n) = r_extended(aa:bb)*h_est'; 
end
