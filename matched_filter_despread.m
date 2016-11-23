function output = matched_filter_despread(noisy_signal, scaledONE, scaledZERO, walshvector)

output = zeros(1, (walshvector));                                            %% defined length for the output of detector
k=1;
for i = 1:length(scaledONE):length(noisy_signal)
    x = corr2(noisy_signal(i:i+length(scaledONE)-1), scaledONE);             %% correlation between incoming sequence and template for 1 
    y = corr2(noisy_signal(i:i+length(scaledONE)-1),scaledZERO);             %% correlation between incoming sequence and template for 0
    if x>y
        output(k:(k+1)-1) = 1;
    else
        output(k:(k+1)-1) = 0;
    end    
    k=k+1;
end

return