function str = bits_to_str(bits)
%% decode
w = [128 64 32 16 8 4 2 1];
Nbits = numel(bits);
Ny = Nbits/8;
msg = zeros(1,Ny);
for i = 0:Ny-1
    msg(i+1) = w*bits(8*i+(1:8));
end
str = char(msg);
end

