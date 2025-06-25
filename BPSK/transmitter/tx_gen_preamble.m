function preamble = tx_gen_preamble(len_preamble)
%生成前导码啊
preamble = zeros(1,len_preamble);
for k=0:len_preamble-1
    Q1(k+1)=pi*k^2./len_preamble;
end
I = cos(Q1);
Q = sin(Q1);
preamble = Q+1i*I;
preamble=preamble.';
end

