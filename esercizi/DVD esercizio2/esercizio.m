clear all
close all
s = tf('s')

F = -0.65 / (s^3+4*s^2+1.75*s)
A = 9
Tp = 1
d1 = 5.5e-3
d2 = 5.5e-3%t

Kf = dcgain(s*F)
%NON poli in C
Kc1 = 1 / (A*Kf*0.2)

Kc2 = (5.5e-3) / (A*6e-4) 

Kc3 = (5.5e-3) / (Kf*A*1.5e-3) 

Kc = 1.5

%studio del segno
figure,nyquist(F)
%segno negativo
Kc = -1.5

%analisi specifiche dinamiche
%ts<=1
%wbmax = 3
wcd = 1.89

%sovraelongazione minore 30%
%Mr = 13/9 --> 3.2
%margine di fase da Nichols 39 gradi
%margine di fase da formula 44 gradi

Ga1 = Kc * F * A * Tp
figure,bode(Ga1)

% rete anticipatrice
md = 4
xd = 0.87
taud = xd/wcd
Rd = (s*taud+1) / (s*taud/md+1)
Ga2 = Ga1 * Rd^2

[m,f]=bode(Ga2,wcd)

figure,margin(Ga2)
C = Kc * Rd^2

W = feedback (C*F*A,Tp)
figure,step(W)
figure,bode(W)

%specifiche dinamiche soddisgìfatte
%specifiche statiche soddisfatte

%calcolo altri parametri
%banda passante --> 3.28
%picco di risonanza --> 3.01db

%il valore massimo in modulo del comando che può essere indotto dal
%disturbo dp in retroazione (dp =10^-3sin(30t))

sens = feedback(1,Ga2)
umax = bode(-C*sens,30) * 10e-3 
