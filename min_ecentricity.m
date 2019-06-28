
function  min_ecentricity(Mux,Muy,Pu,XDim,YDim,effective_length,DIA_C)
  
      if DIA_C == 0 
          ex = Mux*1000000/Pu*1000;
          ey = Muy*1000000/Pu*1000;
          emin_x = effective_length/500+YDim/30;
          emin_y = effective_length/500+XDim/30;
             if emin_x>20
                disp("No modifications is required in Section of Column")
             elseif emin_y>20
                disp("No modifications is required in Section of Column")
              else
                disp("Modifications is required in Section of Column")
              endif
              
      else DIA_C ~= 0
          ex = Mux*1000000/Pu*1000;
          ey = Muy*1000000/Pu*1000;
          emin_x = effective_length/500+DIA_C/30;
          emin_y = effective_length/500+DIA_C/30;
            if emin_x>20
              disp("No modifications is required in diameter of Column")
            elseif emin_y>20
             disp("No modifications is required in diameter of Column")
            else
             disp("Modifications is required in diameter of Column")
            endif
       endif
endfunction
