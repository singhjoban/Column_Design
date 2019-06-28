
function reinf_check(p_provided,p)
  
% This function if to check the reinforcemeent provided is ok or not
% p is the percentage of steel calculated
% p_provided is the percentage of steel provided
  
Per = p_provided + 0.1*p;

      if Per>p
          disp("Reinforcement provided is OK")
      else
          disp("Reinforcement provided is not OK")
      endif
  
endfunction
