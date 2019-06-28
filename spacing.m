
function [Spacing_between_lateral_ties] =spacing(YDim,NominalDiameter,DIA_C)

% D is the depth of column
% dia_of_bar is the diameter of bar used 
% conditions for spacing between lateral ties according to IS 456:2000
   if DIA_C == 0 
      Spacing  = [300 YDim 16*NominalDiameter];
      Spacing_between_lateral_ties = min(Spacing);
printf("Spacing_between_lateral_ties = %d mm \n",Spacing_between_lateral_ties)
    else DIA_C ~= 0
      Spacing  = [300 DIA_C 16*NominalDiameter];
      Spacing_between_lateral_ties = min(Spacing);
printf("Spacing_between_lateral_ties = %d mm \n",Spacing_between_lateral_ties)
   endif
endfunction
