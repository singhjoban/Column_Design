
function SR(effective_length,XDim,YDim,DIA_C)
     if DIA_C == 0 
        SR_b =  effective_length/XDim;
        SR_D =  effective_length/YDim;
          if SR_D<12
             disp("Design as Short Column")
          elseif SR_b<12
             disp("Design as Short Column")
          else
             disp("Design as Slender Column")
          endif
     else DIA_C ~=0
          SR_b =  effective_length/DIA_C;
          SR_D =  effective_length/DIA_C;
          if SR_D<12
              disp("Design as Short Column")
          elseif SR_b<12
              disp("Design as Short Column")
           else
              disp("Design as Slender Column")
          endif
      endif

endfunction
