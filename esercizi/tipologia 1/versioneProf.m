clear all
close all
clear all
close all
s=tf('s');
F1p=30/(s+15); 
F2p=(3*s+3)/(s^3+10*s^2+24*s);
K1=dcgain(F1p)
K2=dcgain(s*F2p)

Kr = 1
Kc = 40
wcd = 14

Ga1=Kc/Kr*F1p*F2p
bode (Ga1)

% Rete anticipatrice
md=12; 
wtaud=2; 
taud=wtaud/wcd; 
Rd=(1+taud*s)/(1+taud/md*s); 
Ga2=Rd*Ga1; % funzione di trasferimento d’anello comprendente anche la rete anticipatrice
[m2,f2]=bode(Ga2,wcd)

% Rete attenuatrice 
mi=2;
wtaui=50;
taui=wtaui/wcd;
Ri=(1+taui/mi*s)/(1+taui*s);
Ga3=Ri*Ga2;
%funzione di trasferimento d’anello comprendente anche la rete attenuatrice
figure,margin(Ga3)

Cp = Kc * Rd * Ri

W = feedback ( Cp * F1p * F2p, 1/Kr)
figure,step(W)
figure,bode(W)

