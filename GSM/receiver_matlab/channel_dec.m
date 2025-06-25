function [rx_block,FLAG_SS,PARITY_CHK] = channel_dec(rx_enc)
%
% channel_dec: 
%
% SYNTAX:     [rx_block, FLAG_SS, PARITY_CHK] = channel_dec(rx_enc)
% 
% INPUT:      rx_enc  A 456 bits long vector contaning the encoded 
%                     data sequence as estimated by the SOVA. The 
%                     format of the sequency must be according to 
%                     the GSM 05.03 encoding scheme
%
% OUTPUT:     rx_block  A 260 bits long vector contaning the final
%                       estimated information data sequence.
%
%             FLAG_SS Indication of correct stop state. Flag is set
%                     to '1' if an error has occured here.
%
%             PARITY_CHK The 3 parity check bit inserted in the 
%                        transmitter.
% 					 
% SUB_FUNC:   None
%
% WARNINGS:   None
%
% TEST(S):    Operation tested in conjunction with the channel_enc.m
%             module. Operation proved to be correct.
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: channel_dec.m,v 1.8 1998/02/12 10:53:13 aneks Exp $

L = length(rx_enc);

% TEST INPUT DATA
%
if L ~= 456
  disp(' ')
  disp('Input data sequence size violation. Program terminated.')
  disp(' ') 
 % break;
end

% separate data in class i, c1, and classe ii, c2, bits
% class i bits are decoded while class ii are left
% unchanged
%

c1 = rx_enc(1:378);
c2 = rx_enc(379:L);

% initialize various matrixes
%
% remember the va decoder operates on di-bits
% hence only 378/2 = 189 state transitions occure
%

START_STATE = 1;
END_STATE = 1;

STATE = zeros(16,189);
METRIC = zeros(16,2);

NEXT = zeros(16,2);
zeroin = 1;
onein = 9;
for n = 1:2:15,
  NEXT(n,:) = [zeroin onein];
  NEXT(n+1,:) = NEXT(n,:);
  zeroin = zeroin + 1;
  onein = onein + 1; 
end

PREVIOUS = zeros(16,2);
offset = 0;
for n = 1:8,
  PREVIOUS(n,:) = [n+offset n+offset+1];
  offset = offset + 1;
end
PREVIOUS = [ PREVIOUS(1:8,:) ; PREVIOUS(1:8,:)];

% setup of dibit decoder table. the binary dibits are
% here represented using decimal number, i.e. the dibit
% 00 is represented as 0 and the dibit 11 as 3
%
% the tabel is setup so that the call dibit(x,y) returns
% the dibit symbol resulting from a state transition from
% state x to state y
% 

DIBIT = [  0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN NaN NaN NaN;
	   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN;
	 NaN   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN;
	 NaN   0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN NaN NaN;
	 NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN NaN;
	 NaN NaN   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN;
	 NaN NaN NaN   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN;
	 NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN;
	 NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN;
	 NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN;
	 NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN;
	 NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN;
	 NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2 NaN;
	 NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1 NaN;
	 NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1;
	 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2];

% setup of bit decoder table. 
% the tabel is setup so that the call bit(x,y) returns
% the decoded bit resulting from a state transition from
% state x to state y
% 					
       
BIT = [  0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN;
	 0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN;
       NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN;
       NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN;
       NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN;
       NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN;
       NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN;
       NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN;
       NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN;
       NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN;
       NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN;
       NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN;
       NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN;
       NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN;
       NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1;
       NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1];
       
% startup metrik calculations.
%
% this is to reduce the number of calculations required
% and it it run only for the first 4 dibit pairs
%
	   
VISITED_STATES = START_STATE;
for n = 0:3,

  rx_DIBITXy = c1(2*n + 1); 
  rx_DIBITxY = c1(2*n + 1 + 1);

  for k = 1:length(VISITED_STATES),

    PRESENT_STATE = VISITED_STATES(k);
    
    next_state_0 = NEXT(PRESENT_STATE,1);  
    next_state_1 = NEXT(PRESENT_STATE,2);
    
    symbol_0 = DIBIT(PRESENT_STATE,next_state_0);
    symbol_1 = DIBIT(PRESENT_STATE,next_state_1);
        
    if symbol_0 == 0
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_0 == 1
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_0 == 2
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_0 == 3
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end
    
    METRIC(next_state_0,2) = METRIC(PRESENT_STATE,1) + LAMBDA;

    if symbol_1 == 0
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 1
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_1 == 2
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 3
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end
    
    METRIC(next_state_1,2) = METRIC(PRESENT_STATE,1) + LAMBDA;
    STATE([next_state_0, next_state_1],n + 1) = PRESENT_STATE; 

    if k == 1
      PROCESSED = [next_state_0 next_state_1]; 
    else
      PROCESSED = [PROCESSED next_state_0 next_state_1];  
    end
  end	   

  VISITED_STATES = PROCESSED;
  METRIC(:,1) = METRIC(:,2);
  METRIC(:,2) = 0; 
end


% starting the section where all states are run through
% in the metric calculations. this goes on for the
% remaining dibits received
%

for n = 4:188,
  
  rx_DIBITXy = c1(2*n + 1); 
  rx_DIBITxY = c1(2*n + 1 + 1);

  for k = 1:16,
    
    prev_state_1 = PREVIOUS(k,1);
    prev_state_2 = PREVIOUS(k,2);
	   
    symbol_1 = DIBIT(prev_state_1,k);
    symbol_2 = DIBIT(prev_state_2,k);
        
    if symbol_1 == 0
      LAMBDA_1 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 1
      LAMBDA_1 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_1 == 2
      LAMBDA_1 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 3
      LAMBDA_1 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end   
	   
    if symbol_2 == 0
      LAMBDA_2 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_2 == 1
      LAMBDA_2 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_2 == 2
      LAMBDA_2 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_2 == 3
      LAMBDA_2 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end     
	   
    METRIC_1 = METRIC(prev_state_1,1) + LAMBDA_1;
    METRIC_2 = METRIC(prev_state_2,1) + LAMBDA_2;
    
    if METRIC_1 < METRIC_2
      METRIC(k,2) = METRIC_1;
      STATE(k,n+1) = prev_state_1;
    else
      METRIC(k,2) = METRIC_2;
      STATE(k,n+1) = prev_state_2;
    end
  end

  METRIC(:,1) = METRIC(:,2);
  METRIC(:,2) = 0;

end

% starting backtracking to determine the most
% probable state transition sequence
%

STATE_SEQ = zeros(1,189);

[STOP_METRIC, STOP_STATE] = min(METRIC(:,1));

if STOP_STATE == END_STATE
  FLAG_SS = 0;
else
  FLAG_SS = 1;
end

STATE_SEQ(189) = STOP_STATE;

for n = 188:-1:1,
  STATE_SEQ(n) = STATE(STATE_SEQ(n+1), n+1);
end

STATE_SEQ = [START_STATE STATE_SEQ];

% resolving the corresponding bit sequencs
%

for n = 1:length(STATE_SEQ)-1,
  DECONV_DATA(n) =  BIT(STATE_SEQ(n), STATE_SEQ(n+1));
end

% separating the data according to the encoding 
% resulting from the transmitter.
%

DATA_Ia = DECONV_DATA(1:50);
PARITY_CHK = DECONV_DATA(51:53);
DATA_Ib = DECONV_DATA(54:185);
TAIL_BITS = DECONV_DATA(186:189);

rx_block = [DATA_Ia DATA_Ib c2];