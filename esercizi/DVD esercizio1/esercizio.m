clear all
close all

s = tf('s')
F1 = 30/(s+15)
F2 = (3*s+3) / (s^3 + 10*s^2 + 24*s)
Kr = 1
d1 = 1
d2 = 4

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)
%NON abbiamo bisogno di poli nell'origine

%analisi specifiche statiche
%errore di inseguimento alla rampa < 0.1

Kc1 = Kr / (Kf1 * Kf2 * 0.1)

%effetto del d1 < 0.05
Kc2 = 1/(0.05*Kf1)

Kc = 40

%studio del segno
%Kf1 e Kf2 concordi--> ok
%poli a parte Re<0 --> ok
figure,bode(F1*F2)
% un solo passaggio per 180 gradi e 0db --> ok

%Kc positivo

%analisi specifiche dinamiche

%wb = 20 (18<wb<22)
wcd = 12.6

%sovraelongazione <= 20%
%Mr = 4/3 --> 2.5db
%margine di fase da Nichols 42
%margine di fase da formula 47.5

Ga1 = Kc * F1 * F2
figure,bode(Ga1)

%decidiamo di recuperare 53 gradi

%rete anticipatrice
md = 3
xd = 1
taud = xd / wcd
Rd = (s*taud+1) / (s*taud/md+1)
Ga2 = Ga1 * Rd^2

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 1.8
bode((1+s/mi)/(1+s))
xi = 30
taui = xi / wcd
Ri = (s*taui/mi+1) / (s*taui+1)
Ga3 = Ga2 * Ri

figure,margin (Ga3)

C = Kc * Rd^2 * Ri
W = feedback(C*F1*F2,1)
figure,step(W)
figure,bode(W)

%specifiche dinamiche soddisfatte

%parametri utili
%tempo salita --> 0.156
%picco di risonanza --> 1.44
%errore di inseguimento massimo ad sin(0.2*t)

sens = feedback(1,Ga3)
errorsens = bode(sens,0.2)

%discretizzazione
wb = 21.9
T = 2*pi/(20*wb)
T = 0.007
Gazoh = Ga3 / (1+T/2*s)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')

%tustin è il migliore