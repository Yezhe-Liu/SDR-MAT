function bits_descramble = derandomizer(scramble_int,data_bits)

for k=1:length(data_bits)
    fdB=bitxor(scramble_int(14),scramble_int(15));
    scramble_int=[fdB scramble_int(1:end-1)];
    bits_descramble(k)=bitxor(data_bits(k),fdB);
end
end