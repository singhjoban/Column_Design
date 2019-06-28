
function[Puz alpha_n] =  alpha(Pu,Ag_col,fck,fy,Total_Ast_provided)

 % This function  zis to find the alpha_n which is a constant
 % Pu is the axial Load
 % Ag_col is the gross area of column
 % fck os the Characteristics strength of concrete
 % fy is the yield strength of concrete
 % Total area of steel provided
 
Puz = (0.45*fck*Ag_col+ (0.75*fy-0.45*fck)*Total_Ast_provided)/1000;
Ratio_Pu_Puz = Pu/Puz;

        if Ratio_Pu_Puz<0.2
             alpha_n = 1;
        elseif Ratio_Pu_Puz>0.8
             alpha_n = 2;
        else
             alpha_n = 0.667+1.667*Ratio_Pu_Puz;
        endif

endfunction
