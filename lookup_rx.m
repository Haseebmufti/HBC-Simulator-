function [orthogonal_mapping_table]=lookup_rx(input)
difference = 0;                                              %% the difference between the incoming sequence and the table sequence
index = 0;                                                   %% index where the difference is highest

  box=[[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
       [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
       [1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0];
       [1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1];
       [1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0];
       [1 0 1 0 0 1 0 1 1 0 1 0 0 1 0 1];
       [1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1];                    %% orthogonal code from line (5 to 20)
       [1 0 0 1 0 1 1 0 1 0 0 1 0 1 1 0];
       [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
       [1 0 1 0 1 0 1 0 0 1 0 1 0 1 0 1];
       [1 1 0 0 1 1 0 0 0 0 1 1 0 0 1 1];
       [1 0 0 1 1 0 0 1 0 1 1 0 0 1 1 0];
       [1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1];
       [1 0 1 0 0 1 0 1 0 1 0 1 1 0 1 0];
       [1 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0];
       [1 0 0 1 0 1 1 0 0 1 1 0 1 0 0 1];];
   
   for i = 1: size(box,1)                                         %% for comparison for the length of the orthogonal code 
       if sum(box(i,:) == input) > difference                          %% compares input sequence with table, stores the no. of difference between incoming data and table
           index=i;                                               %% stores the index of the table with the respective difference
           difference = sum(box(i,:) == input);                        %% if the another index has lesser match value it will update the index 
       end                                                        %% if the two lesser indexes are have same match value, it will be the eariler value in it.
   end

  orthogonal_mapping_table = de2bi(index-1, 4,'left-msb');        %% the comparison with the repective binary values. 

  return