function msg_bits = str_to_bits(msgStr)

msgBin = de2bi(int8(msgStr),8,'left-msb');
len = size(msgBin,1).*size(msgBin,2);
msg_bits = reshape(double(msgBin).',len,1).';

% msg_bits = reshape(msg_bits,120, length(msg_bits)./120);

end

