function [orthogonal_mapping_table]=orthogonal_conversion_table_lookup(input)

orthogonal_mapping_table=[];

switch (mat2str(input))
  case mat2str([0 0 0 0])
orthogonal_mapping_table = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
  case mat2str([0 0 0 1]) 
orthogonal_mapping_table = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
  case mat2str([0 0 1 0])
orthogonal_mapping_table = [1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0];
  case mat2str([0 0 1 1])
orthogonal_mapping_table = [1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1];
  case mat2str([0 1 0 0])
orthogonal_mapping_table = [1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0];
  case mat2str([0 1 0 1]) 
orthogonal_mapping_table = [1 0 1 0 0 1 0 1 1 0 1 0 0 1 0 1];
  case mat2str([0 1 1 0])
orthogonal_mapping_table = [1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1];
  case mat2str([0 1 1 1])
orthogonal_mapping_table = [1 0 0 1 0 1 1 0 1 0 0 1 0 1 1 0];
  case mat2str([1 0 0 0])
orthogonal_mapping_table = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
  case mat2str([1 0 0 1]) 
orthogonal_mapping_table = [1 0 1 0 1 0 1 0 0 1 0 1 0 1 0 1];
  case mat2str([1 0 1 0])
orthogonal_mapping_table = [1 1 0 0 1 1 0 0 0 0 1 1 0 0 1 1];
  case mat2str([1 0 1 1])
orthogonal_mapping_table = [1 0 0 1 1 0 0 1 0 1 1 0 0 1 1 0];
  case mat2str([1 1 0 0])
orthogonal_mapping_table = [1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1];
  case mat2str([1 1 0 1]) 
orthogonal_mapping_table = [1 0 1 0 0 1 0 1 0 1 0 1 1 0 1 0];
  case mat2str([1 1 1 0])
orthogonal_mapping_table = [1 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0];
  case mat2str([1 1 1 1])
orthogonal_mapping_table = [1 0 0 1 0 1 1 0 0 1 1 0 1 0 0 1];
    otherwise
        disp('sequence mismatch');
end


return