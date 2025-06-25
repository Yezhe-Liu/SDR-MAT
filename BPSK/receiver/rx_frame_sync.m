function [frame_index] = rx_frame_sync(rx_bits, SFD)
%寻找帧定界符，SFD标志开始

index=0;

m = 0;


for i=1:length(rx_bits)-16
    
    index=index+1;
    m = m+1;
    y(m) = rx_bits(i);
    if m>15
        if y(m-15:m) == SFD
            fprintf('Find SFD...\n'); 
            frame_index = index;
            break;
        else
            m=0; 
            frame_index = -1;
        end
    end
end