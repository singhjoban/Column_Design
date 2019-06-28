clc
clear all

StaadTable= [csvread('Sample1_Staad.csv',1,0)];
%load input.mat
load strain.mat

outputmacro = "Script_FreeCAD.py";
rein_detail = fopen (outputmacro, "w");
fdisp (rein_detail, "import FreeCAD")
fdisp (rein_detail, "import StraightRebar");
fdisp (rein_detail, "import Stirrup");

Inputifcopenshell= [csvread('octave_input_C.csv',1,0)];
input_name = fopen('octave_input_C.csv') ;
SS = textscan(input_name,'%s','delimiter','\n','HeadeRLines',1);

for t = 1:rows(Inputifcopenshell)
SR_NO=(Inputifcopenshell(t,1));
z =SS{1}{t};
z1 = strsplit(z,',') ;
Name = z1{1,2} ;
name=num2cell(Name) ;
nam=name{1,2};
abc=nam-1;
if abc ~= 48
 
else
# input all Data
SR_NO=(Inputifcopenshell(t,1))  
Name = z1{1,2} 
XDim_1 = (Inputifcopenshell(t,3))*1000 ;
YDim_1 = (Inputifcopenshell(t,4))*1000 ;
effective_length = (Inputifcopenshell(t,5))*1000 ;
fck = Inputifcopenshell(t,6) ;
P = StaadTable(t,2) ;
MuX = StaadTable(t,3);
MuZ = StaadTable(t,4);
DIA_C = (Inputifcopenshell(t,7))*1000 ;
fy=500;
Effective_cover = 40 ;
dia_of_bar = 12;
dia_ties = 8 ;

       if (XDim_1 >= YDim_1)
          XDim = YDim_1 ;
          YDim = XDim_1 ;
       else
          XDim = XDim_1 ;
          YDim = YDim_1 ;
       endif

SP16
Pu = 1*P  ;
Mux = 1.0*MuX ;
Muy = 1.0*MuZ ;

  if DIA_C == 0
#abc = 1
printf("XDim = %d mm \n",XDim	)
printf("YDim = %d mm \n",YDim	)

%% check for selenderness ratio
SR(effective_length,XDim,YDim,DIA_C);

%Check for minimum ecentricity
%Trial Section
Mu1  = (sqrt(Mux*Mux+Muy*Muy)) ;

%% mu and pu is the X-axis and Y-axis of the chart respectively
Pt =[0 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24 0.26 ];
jJ = columns(Pt);
pu= Pu*1000/(fck*XDim*YDim) ;
       if pu>1.28
         disp("Load is very high Change the Section")
       else 
        for j =1:jJ
        m1= interp1(Tables(:,j,1),Table(:,j,1),pu);
        Tab(j,2) = [m1];
        Tab (j,1) = [j];
        endfor
mu = Mu1*1000000/(fck*XDim*YDim*YDim);
[m,n] = min(abs(mu-Tab(:,2)));
Curve_number = Tab(n);
p_by_fck = interp1(percentage(:,1),percentage(:,2),Curve_number);
% p is the percentage of reinforcement
p = p_by_fck*fck;
         if p>5
            disp("Change the section p>4.5 ")
         elseif p<= 0.8
          for k =1:100
          disp("Provide minimum area of steel")
          Ast_min = (0.8*XDim*YDim)/100;
          printf("Minimum Area of Steel = %d mm^2 \n",Ast_min	)
% If want from user 
#NominalDiameter = input('Diameter of Bar used in minimum area of steel = ') 
NominalDiameter= 12 
Ast_of_one_bar = (pi/4)*(NominalDiameter)*(NominalDiameter);
Required_no_bars = round(Ast_min/Ast_of_one_bar)
No_of_bars_on_one_side_along_D = ceil(Required_no_bars/4)+1
No_of_bars_on_one_side_along_b = ceil(Required_no_bars/4)+1
Total_no_of_bars=2*(No_of_bars_on_one_side_along_D+No_of_bars_on_one_side_along_b)

%four corners bars are averlapped so they are deducted from total no. of bars
Actual_no_of_bars_provided = Total_no_of_bars-4
Total_Ast_provided = Actual_no_of_bars_provided* Ast_of_one_bar 
printf("Total Area of Steel Provided = %d mm^2 \n",Total_Ast_provided)
spacing_between_bars = (YDim - 2*Effective_cover-2*dia_ties-NominalDiameter)/(No_of_bars_on_one_side_along_D-1);
printf("Spacing_between_bars = %d mm \n",spacing_between_bars)
p_provided = (Total_Ast_provided/(XDim*YDim))*100

#disp("do you want to change dia ")
Spacing_between_lateral_ties =spacing(YDim,NominalDiameter,DIA_C) ;

#V = input('type 1 for yes and 0 for no = ');
V=0;
    if V == 1 
      k =k+1;
    else 
      printf("Total Area of Steel Provided = %d mm^2 \n",Total_Ast_provided)
      Actual_no_of_bars_provided = Total_no_of_bars-4
      p_provided = (Total_Ast_provided/(XDim*YDim))*100
       break
    endif
            endfor
else
  
printf("Percentage of Steel required = %d  \n",p)
#disp("\n")

% Calculation of Required Area of Steel
% if NominalDiameter fail in case of spacing it will increase to next 
NominalDiameter = [dia_of_bar dia_of_bar+4 dia_of_bar+8 dia_of_bar+13 dia_of_bar+20];
iI = columns(NominalDiameter);

         for i = 1:iI
           disp("Trial")
           Ast_reqd = (p*XDim*YDim)/100;
           Ast_max = 0.05*XDim*YDim;
           Ast_of_one_bar = (pi/4)*(NominalDiameter(i))*(NominalDiameter(i));
           Required_no_bars = ceil(Ast_reqd/Ast_of_one_bar);
           No_of_bars_on_one_side_along_D = ceil(Required_no_bars/4)+1;
           No_of_bars_on_one_side_along_b = ceil(Required_no_bars/4)+1;

Total_no_of_bars=2*(No_of_bars_on_one_side_along_D+No_of_bars_on_one_side_along_b);
%four corners bars are averlapped so they are deducted from total no. of bars
Actual_no_of_bars_provided = Total_no_of_bars-4;
Total_Ast_provided = ceil(Actual_no_of_bars_provided* Ast_of_one_bar);
Minimum_Spacing_between_bars = 30 + NominalDiameter(i);
spacing_between_bars = (YDim-2*Effective_cover-2*dia_ties-NominalDiameter(i))/(No_of_bars_on_one_side_along_D-1);

      if spacing_between_bars<Minimum_Spacing_between_bars
  
      elseif spacing_between_bars>Minimum_Spacing_between_bars
       Spacing_between_main_bars = spacing_between_bars;
       
printf("NominalDiameter = %d mm \n", NominalDiameter(i))
printf("Required Area of Steel = %d mm^2 \n",Ast_reqd 	)
#disp("Provide Ast_reqd equally on four sides")
printf("Maximum Area of Steel = %d mm^2 \n",Ast_max	)
#printf("Area of one bar = %d mm^2 \n",Ast_of_one_bar	)
printf("Required_no_bars = %d  \n",Required_no_bars 	)
printf("No_of_bars_on_one_side_along_D = %d  \n",No_of_bars_on_one_side_along_D)
printf("No_of_bars_on_one_side_along_b = %d  \n",No_of_bars_on_one_side_along_b)
printf("Total_no_of_bars = %d  \n",  Total_no_of_bars  	)
printf("Actual_no_of_bars_provided = %d  \n",  Actual_no_of_bars_provided 	)
printf("Total_Ast_provided = %d  \n",Total_Ast_provided)
printf("Spacing_between_main_bars = %d mm \n",Spacing_between_main_bars)
# Data used in freeCad 
      break
      endif

          endfor

p_provided = (Total_Ast_provided/(XDim*YDim))*100
      if p_provided>5
      disp("CHECK now \n Reinforcement exceeded the maximum reinforcement")
      disp("Change the section")
      elseif p_provided<=0
      Ast_reqd = 0.008*XDim*YDim
      else
      p_by_fck_provided = p_provided/fck;
      Ast_min_col= 0.008*XDim*YDim;
      printf("Minimum area of steel = %d mm^2 \n",Ast_min_col)
    if Total_Ast_provided>Ast_min_col
     disp("Total Area of steel provided is more than minimum Area of steel")
    else
     disp("Total Area of Steel provided is less than minimum area of steel")
     printf("Minimum area of steel = %d mm^2 \n",Ast_min_col)
    endif

reinf_check(p_provided,p)

%%Bending about X-axis
D_1 = [Effective_cover/YDim Effective_cover/XDim];
kK = columns(D_1);
Curve_number1= (interp1(percentage(:,2),percentage(:,1),p_by_fck_provided));
curve_number = ceil(Curve_number1+1);
pu= Pu*1000/(fck* XDim*YDim);
m11= interp1(Tables(:,curve_number,1),Table(:,curve_number,1),pu);
Mux1 = m11*fck*XDim*YDim*YDim;

%% values of Puz and alpha_n
Ag_col = XDim*YDim;
[Puz alpha_n] =  alpha(Pu,Ag_col,fck,fy,Total_Ast_provided);
Curve_number11 = (interp1(percentage(:,2),percentage(:,1),p_by_fck_provided));
Curve_number2 = ceil(Curve_number11+1);
pu= Pu*1000/(fck* XDim*YDim);
m12= interp1(Tables(:,Curve_number2,2),Table(:,Curve_number2,2),pu);
Muy1 = m12*fck* XDim*YDim*YDim;
%%Check safety under biaxial bending
check(Mux1,Mux,alpha_n,Muy1,Muy)
printf("Load Carrying Capacity of column = %d KN \n",Puz)
printf("Diameter of lateral ties = %d mm \n",dia_ties )
 Spacing_between_lateral_ties =spacing(YDim,NominalDiameter(i),DIA_C) ;

  if Spacing_between_main_bars<75
  disp("Provide only outer ties")
  elseif Spacing_between_main_bars>150
   disp("Provide ties to every bar")
  else 
disp("Provide alterante ties")
  endif
      endif
disp("\n")
endif
endif

%Design of Circle Column 

else DIA_C ~= 0
    printf("Diameter of circular column = %d mm \n",DIA_C)
    
%% check for selenderness ratio
SR(effective_length,XDim,YDim,DIA_C);

%Check for minimum ecentricity
%Trial Section
Mu1  = (sqrt(Mux*Mux+Muy*Muy));
%% mu and pu is the X-axis and Y-axis of the chart respectively
Pt =[0 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24 ];
jJ = columns(Pt);
pu= Pu*1000/(fck*DIA_C*DIA_C);
    if pu>1.28
    disp("Load is very high Change the Section")
    else 
      for j =1:jJ
        m1= interp1(Tables(:,j,1),Table(:,j,1),pu);
        Tab(j,2) = [m1];
        Tab (j,1) = [j];
      endfor
mu = Mu1*1000000/(fck*DIA_C*DIA_C*DIA_C);
[m,n] = min(abs(mu-Tab(:,2)));
Curve_number = Tab(n+1);
p_by_fck = interp1(percentage(:,1),percentage(:,2),Curve_number);

% p is the percentage of reinforcement
p = p_by_fck*fck;
if p>5
  disp("Change the section")
elseif p<= 0.8 
  disp("Provide minimum area of steel")
     for k =1:100
  disp("Provide minimum area of steel")
  Ast_min = (0.8*DIA_C*DIA_C)/400;
  printf("Minimum Area of Steel = %d mm^2 \n",Ast_min	)
  % enter Dia if want manulay
  #NominalDiameter = input('Diameter of Bar used in minimum area of steel = ')
  NominalDiameter = 12
    
Ast_of_one_bar = (pi/4)*(NominalDiameter)*(NominalDiameter);
Required_no_bars = round(Ast_min/Ast_of_one_bar)
No_of_bars_on_one_side_along_D = round(Required_no_bars/4)+1;
No_of_bars_on_one_side_along_b = round(Required_no_bars/4)+1;
Total_no_of_bars=2*(No_of_bars_on_one_side_along_D+No_of_bars_on_one_side_along_b);

%four corners bars are averlapped so they are deducted from total no. of bars
Actual_no_of_bars_provided = Total_no_of_bars-4
Total_Ast_provided = Actual_no_of_bars_provided* Ast_of_one_bar;
printf("Total Area of Steel Provided = %d mm^2 \n",Total_Ast_provided)
spacing_between_bars = (DIA_C - 2*Effective_cover-2*dia_ties-NominalDiameter)/(No_of_bars_on_one_side_along_D-1);
printf("Spacing_between_bars = %d mm \n",spacing_between_bars)
p_provided = (Total_Ast_provided/(DIA_C*DIA_C))*400
  
#disp("do you want to change dia ")
#V = input('type 1 for yes and 0 for no = ');
V=0;
     if V == 1
      k =k+1;
     else 
       printf("Total Area of Steel Provided = %d mm^2 \n",Total_Ast_provided)
       Actual_no_of_bars_provided = Total_no_of_bars-4
       p_provided = (Total_Ast_provided/(DIA_C*DIA_C))*400;
     break
     endif
 
    endfor
else
disp("\n")

% Calculation of Required Area of Steel
NominalDiameter = [dia_of_bar dia_of_bar+4 dia_of_bar+8 dia_of_bar+13 dia_of_bar+20  dia_of_bar+28];
iI = columns(NominalDiameter);
    for i=1:iI
    Ast_reqd = (p*pi*DIA_C*DIA_C)/400;
    Ast_max = (0.045*pi*DIA_C*DIA_C)/4;
    Ast_of_one_bar = (pi/4)*(NominalDiameter(i))*(NominalDiameter(i));
    Required_no_bars = ceil(Ast_reqd/Ast_of_one_bar);
    Total_Ast_provided = Required_no_bars* Ast_of_one_bar;
    
spacing_between_bars = (DIA_C - 2*Effective_cover-2*dia_ties-NominalDiameter(i))/(Required_no_bars-1);
Minimum_Spacing_between_bars = 20 + NominalDiameter(i);
    if spacing_between_bars<Minimum_Spacing_between_bars

     elseif spacing_between_bars>Minimum_Spacing_between_bars
       Spacing_between_main_bars = spacing_between_bars;
       printf("NominalDiameter = %d mm \n", NominalDiameter(i))
       printf("Percentage of Steel required = %d  \n",p)
       printf("Required Area of Steel = %d mm^2 \n",Ast_reqd)          
       printf("Maximum Area of Steel = %d mm^2 \n",Ast_max)
       printf("Area of one bar = %d mm^2 \n",Ast_of_one_bar)
       printf("Required_no_bars = %d  \n",Required_no_bars)
       printf("Total_Ast_provided = %d  \n",Total_Ast_provided)
       printf("Spacing_between_main_bars = %d mm \n",Spacing_between_main_bars)
       break
       endif
      endfor
p_provided = (Total_Ast_provided/(pi*DIA_C*DIA_C))*400
  if p_provided>4
    disp("Change the section")
  elseif p_provided<=0.8
   Ast_reqd = 0.008*XDim*YDim
  else
    p_by_fck_provided = p_provided/fck;
    Ast_min_col= (0.008*pi*DIA_C*DIA_C)/4;
# printf("Minimum area of steel = %d mm^2 \n",Ast_min_col)
     if Total_Ast_provided>Ast_min_col
     disp("Total Area of steel provided is more than minimum Area of steel")
     else
     disp("Total Area of Steel provided is less than minimum area of steel")
     printf("Minimum area of steel = %d mm^2 \n",Ast_min_col)
     endif
reinf_check(p_provided,p)

%%Bending about X-axis
D_1 = [Effective_cover/DIA_C];
kK = columns(D_1);
Curve_number1= (interp1(percentage(:,2),percentage(:,1),p_by_fck_provided));
curve_number = ceil(Curve_number1+1);
pu= Pu*1000/(fck* DIA_C*DIA_C);
m11= interp1(Tables(:,curve_number,1),Table(:,curve_number,1),pu);
Mux1 = m11*fck*DIA_C*DIA_C*DIA_C;

%% values of Puz and alpha_n
Ag_col = (pi*DIA_C*DIA_C)/4;
alpha_n =  alpha(Pu,Ag_col,fck,fy,Total_Ast_provided);
Curve_number11= (interp1(percentage(:,2),percentage(:,1),p_by_fck_provided));
Curve_number2 = ceil(Curve_number11+1);
pu= Pu*1000/(fck*DIA_C*DIA_C);
m12= interp1(Tables(:,Curve_number2,1),Table(:,Curve_number2,1),pu);
Muy1 = m12*fck*DIA_C*DIA_C*DIA_C;

%%Check safety under biaxial bending
check(Mux1,Mux,alpha_n,Muy1,Muy);
 Spacing_between_lateral_ties =spacing(YDim,NominalDiameter(i),DIA_C);
    if spacing_between_bars<75
       disp("Provide only outer ties")
    elseif spacing_between_bars>150
       disp("Provide ties Continously")
    else
       disp("Provide alterante ties")
    endif
  endif
disp("\n")
endif
endif
endif

if DIA_C == 0
 
nam1=name{1,1};
nam21=name{1,2};
nam3=name{1,3};
nam4=name{1,4};
nam22 = 2 ;
nam23 = 3  ;

fputs (rein_detail, 'objs = [o for o in FreeCAD.ActiveDocument.Objects if hasattr(o, "IfcType") and o.IfcType == "Column" and o.Label in ["');
fputs (rein_detail, Name );
fputs (rein_detail, '","');
fputs (rein_detail, nam1 ); 
fprintf (rein_detail, '%d', nam22 );
fputs (rein_detail, nam3 );
fputs (rein_detail, nam4 );
fputs (rein_detail, '","');
fputs (rein_detail, nam1 ); 
fprintf (rein_detail, '%d', nam23 );
fputs (rein_detail, nam3 );
fputs (rein_detail, nam4 );
fputs (rein_detail, '"]]');
fdisp (rein_detail, '');
fdisp (rein_detail, 'for o in objs:');
   
fputs (rein_detail, '        StraightRebar.makeStraightRebar(40, ("Left Side", 40), 0, 0, 12, True, ');
fprintf (rein_detail, '%d' , No_of_bars_on_one_side_along_D );
fputs (rein_detail, ' , "Vertical", o, "Face1")');
fdisp (rein_detail, '');

fputs (rein_detail, '        StraightRebar.makeStraightRebar(40, ("Right Side", 40), 0, 0, 12, True, ');
fprintf (rein_detail, '%d' , No_of_bars_on_one_side_along_b );
fputs (rein_detail, ' , "Vertical", o, "Face1")');
fdisp (rein_detail, '');

fputs (rein_detail, '        StraightRebar.makeStraightRebar(40, ("Left Side", 40), 0, 0, 12, True, ');
fprintf (rein_detail, '%d' , No_of_bars_on_one_side_along_D );
fputs (rein_detail, ' , "Vertical", o, "Face2")');
fdisp (rein_detail, '');

fputs (rein_detail, '        StraightRebar.makeStraightRebar(40, ("Right Side", 40), 0, 0, 12, True, ');
fprintf (rein_detail, '%d' , No_of_bars_on_one_side_along_b );
fputs (rein_detail, ' , "Vertical", o, "Face2")');
fdisp (rein_detail, '');

fputs (rein_detail, '        Stirrup.makeStirrup(30, 30, 30, 30, 30, 135, 4, 8, 2, False, ');
fprintf (rein_detail, '%d' , Spacing_between_lateral_ties );
fputs (rein_detail, ' , o, "Face6")');
fdisp (rein_detail, '');
fdisp (rein_detail, "")


else

fdisp (rein_detail, "import HelicalRebar")
fdisp (rein_detail, "import Draft")
fdisp (rein_detail, "Draft.move([FreeCAD.ActiveDocument.Array],FreeCAD.Vector(-2000,0,0.0),copy=True)")
fdisp (rein_detail, "Draft.move([FreeCAD.ActiveDocument.Array],FreeCAD.Vector(2000,0,0.0),copy=True)")
fdisp (rein_detail, "FreeCAD.ActiveDocument.recompute()")
fdisp (rein_detail, 'objs=[ oo for oo in FreeCAD.ActiveDocument.Objects if hasattr(oo, "IfcType") and oo.IfcType =="Column Standard Case" ]')
fdisp (rein_detail, "for oo in objs:")
fdisp (rein_detail, '	    	HelicalRebar.makeHelicalRebar(45, 50, 8, 50, 120, oo, "Face2")')
fdisp (rein_detail, "")

endif
disp("\n")

endif
endfor
fclose (rein_detail);
