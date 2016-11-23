function [despread_walsh]= walshdespreader(fscDespread, fscSize,walsh)
 
 despread_walsh = zeros(1,length(walsh));                                         
 k=1;                                                            %%%  where 1 = [0 1 0 1 0 1 0 1] (for length 1x64)
                                                                 %%%  where 0 = [1 0 1 0 1 0 1 0] (for length 1x64) 
     for i = 1:fscSize:length(fscDespread)

even = fscDespread(i+1:2:i+fscSize-1);                        %%  sum of all the even indexes in the incoming sequence 
odd = fscDespread(i:2:i+fscSize-1);                           %%  sum of all the odd indexes in the incoming sequence

        if sum(odd) > sum(even)
             despread_walsh(k:(k+1)-1) =  0;                  %% compares the sum odd indexes with the even indexes 
        else                                                  %% if the sum of odd indexes is greater than sum of even indexes we get 0 else we get 1
             despread_walsh(k:(k+1)-1)  = 1;
        end
        k=k+1;
    end

return;