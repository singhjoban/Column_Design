
function check(Mux1,Mux,alpha_n,Muy1,Muy)
  
% Mux is the given moment in x-direction
% Muy is the given moment in y-direction
% Mux1 and Muy1 is the inherent resistance by column
% alpha_n is the constant
  
  Check = (Mux*1000000/Mux1)^alpha_n+(Muy*1000000/Muy1)^alpha_n;

    if Check<1
       disp("Check the adequacy of the section") ;
       disp("Trial section is safe under the applied loading") ;
    else
       disp("Check the adequacy of the section") ;
       disp("Check is not safe \n Change the Section")
    endif
endfunction
