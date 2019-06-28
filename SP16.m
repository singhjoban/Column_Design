
if DIA_C == 0
fsc = 0.79*fy;

%% D is the ratio of clear cover to overall depth
%% Pt is the percentage of reinforcement
%% X(i)(i) is the ration of X(i)(i)u_by_D
X = [100 50 20 10 5 1.1 0.591715 0.552922 0.558902 0.488826]; 
iI = columns(X);
Pt =[0 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24 0.26];
jJ = columns(Pt);
D_1 = [Effective_cover/YDim Effective_cover/XDim];
kK = columns(D_1);

for k = 1:kK
for  j = 1:jJ;
for i = 1:iI;
  P1 = 0.446 + (Pt(j)*(fsc - 0.446*fck)/100);
  M1 =0;
 g1= (7*X(i)-3)*(7*X(i)-3);
  g = (16/g1);
      if X(i)<1
         a = 0.362*X(i);
      elseif X(i)>=1
         a = (0.447)*(1-4*g/21);
      endif
  
%% Cc is the resultant Force in concrete 
Cc = a;
           if X(i)<=1       
%% Mc is the resultant moment in concrete
%% Mc = Mc/fck*b*D*D
Mc = Cc*(0.5-0.416*X(i));
           elseif X(i)>1
             Mc = Cc*(0.5-((514.5-168*g)/(1029-196*g)));
           endif

       if X(i)<=1
          strain1 = 0.0035*(1- D_1(k)/X(i));
       elseif X(i)>1
           strain1= (1+((0.428-D_1(k))/(X(i)-0.428)))*0.002;
       endif
       
  if strain1<=0
    fci_1= 0;
  elseif strain1>= 0.002
    fci_1 = 0.447*fck;
  elseif strain1>0
fci_1 = 0.447*fck *((2*strain1)/(0.002)-((strain1)/(0.002)*(strain1)/(0.002)));
endif

        if strain1>0.0038
            fsi_1=360.9;
        elseif strain1<=(-0.0038)
            fsi_1=-360.9;
        else
            fsi_1 = interp1(table(:,1),table(:,2),strain1);
        endif
        
Tablefci_1 = [ fci_1*0.30*(Pt(j)/100) ];
Tablefsi_1 = [ fsi_1*0.30*(Pt(j)/100) ];
TableM1 = [(fci_1*0.30*(Pt(j)/100)*(0.5-D_1(k)))];
TableM_1 = [(fsi_1*0.30*(Pt(j)/100)*(0.5-D_1(k)))];

            if X(i)<=1
                 strain2 = 0.0035*((X(i)-1+D_1(k))/X(i));
            elseif X(i)>1
                 strain2 = (1+((-0.571+D_1(k))/(X(i)-0.428)))*0.002;
            endif
   if strain2<=0
    fci_2 = 0;
  elseif strain2>= 0.002
    fci_2 = 0.447*fck;
  elseif strain2>0
fci_2 = 0.447*fck *((2*strain2)/(0.002)-((strain2)/(0.002)*(strain2)/(0.002)));
  endif

           if strain2>=0.0038
              fsi_2=360.9;
           elseif strain2<=(-0.0038)
              fsi_2=-360.9;
           else
              fsi_2 = interp1(table(:,1),table(:,2),strain2);
           endif

Tablefci_2 =[ fci_2*0.30*(Pt(j)/100) ];
Tablefsi_2 = [ fsi_2*0.30*(Pt(j)/100) ];
TableM2 = [(fci_2*0.30*(Pt(j)/100)*(D_1(k)-0.5))];
TableM_2 = [(fsi_2*0.30*(Pt(j)/100)*(D_1(k)-0.5))];

      if X(i)<=1
         strain4= 0.0035*((X(i)-0.2-D_1(k))/X(i));
      elseif X(i)>1
         strain4= (1+((0.228-D_1(k))/(X(i)-0.428)))*0.002;
      endif
      
 if strain1<=0
   fci_4= 0;
 elseif strain1>= 0.002
   fci_4 = 0.447*fck;
 elseif strain1>0
fci_4 = 0.447*fck *((2*strain4)/(0.002)-((strain4)/(0.002)*(strain4)/(0.002)));
endif

      if strain1>0.0038
          fsi_4=360.9;
      elseif strain1<=(-0.0038)
          fsi_4=-360.9;
      else
          fsi_4 = interp1(table(:,1),table(:,2),strain4);
      endif
      
Tablefci_4 =[ fci_4*0.10*(Pt(j)/100) ];
Tablefsi_4 = [ fsi_4*0.10*(Pt(j)/100) ];
TableM4 = [(fci_4*0.10)*(Pt(j)/100)*(0.7*(1-2*D_1(k)))];
TableM_4 = [(fsi_4*0.10)*(Pt(j)/100)*(0.7*(1-2*D_1(k)))];

          if X(i)<=1
             strain5 = 0.0035*((X(i)-0.4-D_1(k))/X(i));
          elseif X(i)>1
             strain5= (1+((-(0.028)-D_1(k))/(X(i)-0.428)))*0.002;
          endif
          
 if strain5<=0
   fci_5= 0;
 elseif strain1>= 0.002
   fci_5 = 0.447*fck;
 elseif strain1>0
fci_5 = 0.447*fck *((2*strain5)/(0.002)-((strain5)/(0.002)*(strain5)/(0.002)));
 endif
  
      if strain1>0.0038
          fsi_5=360.9;
      elseif strain1<=(-0.0038)
          fsi_5=-360.9;
      else
          fsi_5= interp1(table(:,1),table(:,2),strain5);
      endif
      
Tablefci_5 =[ fci_5*0.10*(Pt(j)/100) ];
Tablefsi_5 = [ fsi_5*0.10*(Pt(j)/100) ];
TableM5 = [(fci_5*0.10)*(Pt(j)/100)*(-1)*(0.1*(1-2*D_1(k)))];
TableM_5= [(fsi_5*0.10)*(Pt(j)/100)*(-1)*(0.1*(1-2*D_1(k)))];

      if X(i)<=1
        strain6 = 0.0035*((X(i)-0.8-D_1(k))/X(i));
      elseif X(i)>1
        strain6= (1+((D_1(k)-0.37142)/(X(i)-0.428)))*0.002;
      endif
 if strain6<=0
   fci_6= 0;
 elseif strain6>= 0.002
   fci_6 = 0.447*fck;
 elseif strain6>0
fci_6 = 0.447*fck*((2*strain6)/(0.002)-((strain6)/(0.002)*(strain6)/(0.002)));
 endif

      if strain6>0.0038
          fsi_6=360.9;
      elseif strain6<=(-0.0038)
          fsi_6=-360.9;
      else
          fsi_6= interp1(table(:,1),table(:,2),strain6);
      endif
      
Tablefci_6 =[ fci_6*0.10*(Pt(j)/100) ];
Tablefsi_6=[ fsi_6*0.10*(Pt(j)/100) ];
TableM6 = [(fci_6*0.10)*(Pt(j)/100)*(-1)*(0.7*(1-2*D_1(k)))];
TableM_6= [(fsi_6*0.10)*(Pt(j)/100)*(-1)*(0.7*(1-2*D_1(k)))];

        if X(i)<=1
          strain7 = 0.0035*((X(i)-0.6-D_1(k))/X(i));
        elseif X(i)>1
           strain7= (1+((D_1(k)-0.1714)/(X(i)-0.428)))*0.002;
         endif
         
 if strain7<=0
   fci_7= 0;
 elseif strain7>= 0.002
   fci_7 = 0.447*fck;
 elseif strain1>0
fci_7 = 0.447*fck *((2*strain7)/(0.002)-((strain7)/(0.002)*(strain7)/(0.002)));
 endif

          if strain7>0.0038
              fsi_7=360.9;
          elseif strain7<=(-0.0038)
              fsi_7=-360.9;
          else
              fsi_7= interp1(table(:,1),table(:,2),strain7);
          endif
          
Tablefci_7 =[ fci_7*0.10*(Pt(j)/100) ];
Tablefsi_7 = [ fsi_7*0.10*(Pt(j)/100) ];
TableM7 = [(fci_7*0.10)*(Pt(j)/100)*(0.1*(1-2*D_1(k)))];
TableM_7= [(fsi_7*0.10)*(Pt(j)/100)*(0.1*(1-2*D_1(k)))];

P_1 = [Tablefci_1+Tablefci_2+Tablefci_4+Tablefci_5+Tablefci_6+Tablefci_7];
Q = [Tablefsi_1+Tablefsi_2+Tablefsi_4+Tablefsi_5+Tablefsi_6+Tablefsi_7];
Cs1= [Q-P_1];

%% Cs is the resultant force in steel 
%% p is the Load in KN
%%P= pu/fck*b*D
P_P = (Cc+Cs1); 
R = [TableM1+TableM2+TableM4+TableM5+TableM6+TableM7];
S = [TableM_1+TableM_2+TableM_4+TableM_5+TableM_6+TableM_7];
  
%% Ms1 = Ms1/fck*b*D*D
Ms1 = [S-R];
M =(Mc+Ms1);  
J1 =0.5-D_1(k); 
J2 = 0.5-D_1(k);
J4 = (0.7*(1-2*D_1(k)));
J5 = (0.1*(1-2*D_1(k)));
J6 = (0.7*(1-2*D_1(k)));
J7 = (0.1*(1-2*D_1(k)));
M2 =(0.79*fy*Pt(j)*J1*0.30+0.79*fy*Pt(j)*J2*0.30+0.79*fy*Pt(j)*J4*0.10+0.79*fy*Pt(j)*J5*0.10+0.79*fy*Pt(j)*J6*0.10+fy*0.79*Pt(j)*J7*0.10)/100;

P2 = 0;
Tables(1,j,k) = [P1];
Table(1,j,k) = [M1];
Table(i,j,k) = [M];
Tables(i,j,k) = [P_P];
Tables(10,j,k) = [P2];
Table(10,j,k) = [M2];

# if you want to see all Graph of Sp16
%Plot
%yy=smooth (P);
%xx=smooth (M);
%figure(k)
%plot(Table(:,:,k),Tables(:,:,k))
#hold on;
#grid;
#title('PM Interaction Diagram');
#ylabel('Pu/fckbD');
#xlabel('Mu/fckb\itD^{2}');
#hold off;
endfor
endfor
endfor

else DIA_C ~= 0
fsc = 0.79*fy;

%% X is the ratio of Xu_by_D
X = [100 50 20 10 5 1.1 0.591715 0.552922 0.518902];
iI = columns(X);

%% Pt is the percentage of reinforcement
Pt =[0 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24 0.26];
jJ = columns(Pt);

%% D is the ratio of clear cover to overall depth
D_1 = [Effective_cover/DIA_C];
kK = columns(D_1);
for k=1:kK;
for j = 1:jJ;
for  i = 1:iI;
P1 = 0.446*0.785+ (Pt(j)*0.785*(fsc - 0.446*fck)/100);
M1 =0;
g1= (7*X(i)-3)*(7*X(i)-3);
g = (16/g1);

          if X(i)<=1
            a = 0.362*X(i);
          elseif X(i)>1
            a = (0.447)*(1-4*g/21);
          endif
  
%% Cc is the resultant Force in concrete 
%% Cc = Cc/fck*b*D
Cc = a*0.785;
           if X(i)<=1
             %% Mc is the resultant moment in concrete
             %% Mc = Mc/fck*b*D*D
                Mc = Cc*(0.5-0.416*X(i));
           elseif X(i)>1
                  Mc = Cc*(0.5-((514.5-168*g)/(1029-196*g)));
           endif

              if X(i)<=1
                 strain1 = 0.0035*(1- D_1(k)/X(i));
              elseif X(i)>1
                 strain1= (1+((0.428-D_1(k))/(X(i)-0.428)))*0.002;
              endif

%% fci is the stress in concrete
% fci_1 and fsi_1 computed corresponding to the strain1
  if strain1<=0
      fci_1= 0;
   elseif strain1>= 0.002
      fci_1 = 0.447*fck;
   elseif strain1>0
fci_1 = 0.447*fck*((2*strain1)/(0.002)-((strain1)/(0.002)*(strain1)/(0.002)));
    endif

% fsi is the stress in steel
      if strain1>0.0038
          fsi_1=360.9;
      elseif strain1<=(-0.0038)
          fsi_1=-360.9;
      else
          fsi_1 = interp1(table(:,1),table(:,2),strain1);
      endif
      
Tablefci_1 = [ fci_1 ];
Tablefsi_1 = [fsi_1];
TableM1 = [(fci_1*0.50*(Pt(j)/100)*0.55*(0.5-D_1(k)))];
TableM_1 = [(fsi_1*0.50*(Pt(j)/100)*0.55*(0.5-D_1(k)))];

        if X(i)<=1
           strain2 = 0.0035*((X(i)-1+D_1(k))/X(i));
        elseif X(i)>1
           strain2 = (1+((-0.571+D_1(k))/(X(i)-0.428)))*0.002;
        endif
 if strain2<=0
% fci_2 and fsi_2 computed corresponding to the strain2
 fci_2 = 0;
 elseif strain2>= 0.002
 fci_2 = 0.447*fck;
 elseif strain2>0
fci_2 = 0.447*fck *((2*strain2)/(0.002)-((strain2)/(0.002)*(strain2)/(0.002)));
 endif

         if strain2>=0.0038;
            fsi_2=360.9;
         elseif strain2<=(-0.0038);
            fsi_2=-360.9;
         else
            fsi_2 = interp1(table(:,1),table(:,2),strain2);
         endif
        
Tablefci_2 = [ fci_2 ] ;
Tablefsi_2 = [fsi_2];
TableM2 = [(fci_2*0.50*(Pt(j)/100)*0.55*(D_1(k)-0.5))];
TableM_2= [(fsi_2*0.50*(Pt(j)/100)*0.55*(D_1(k)-0.5))];
P_11 = [Tablefci_1+Tablefci_2];
Q = [Tablefsi_1+Tablefsi_2];
Cs1= [Q-P];

%% Cs is the resultant force in steel
%% Cs = Cs/fck*b*D*D
Cs = (Cs1*Pt(j)*0.785*0.50)/100;

%% pu is the load, b&D is the dimensions of column
%%P= pu/fck*b*D
P_P = (Cs+Cc);
R = [TableM1+TableM2];
S = [TableM_1+TableM_2];

%% Ms1 = Ms1/fck*b*D*D
Ms1 = [S-R];
M =(Mc+Ms1);

%% M = Mu/fck*b*D*D
J1 = 0.5-D_1(k);
J2 = 0.5-D_1(k);
M2 = (10*Pt(j)/(100*fck))*(0.87*fy)*(J1)*(0.55) + (10*Pt(j)/(100*fck))*(0.87*fy)*(J2)*(0.55) ;
P2 = 0;
Tables(1,j,k) = [P_11];
Table(1,j,k) = [M1];
Table(i,j,k) = [M];
Tables(i,j,k) = [P_P];
Tables(10,j,k) = [P2];
Table(10,j,k) = [M2];

%Plot
%yy=smooth (P);
%xx=smooth (M);

%plot(Table(:,:,k),Tables(:,:,k))
%hold on;
%grid;
%title('PM Interaction Diagram');
%ylabel('Pu/fckbD');
%xlabel('Mu/fckb\itD^{2}');
%hold off;

i=i+1;
endfor
endfor
endfor

endif
