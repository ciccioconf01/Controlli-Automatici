clear all
close all

s = tf('s')
F1 = 2.5 * (1+s) / ((1+0.5*s)^2)
F2 = 30 * (1+0.1*s) / (s*(s+30)^2)
Kr = 1

d1 = 0.01
d2 = 0.2%t

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)
%NON ho bisogno di poli nel controllore

Kc1 = Kr^2 / (Kf1*Kf2*0.5)

Kc2 = (0.01*Kr) / (Kf1*0.01)

Kc3 = (0.2*Kr) / (Kf1*Kf2*0.2)

Kc = 510 %iniziale 24

%studio del segno
%Kf1*Kf2 segno positivo --> ok
%tutti i poli RE<0 --> ok
bode(F1*F2)
%un solo attraversamento di 0db e -180 gradi

%segno positivo

%analisi specifiche dinamiche
%wb circa 35 (31.5 < wb < 38.5)
wcd = 19.9

%sovraelongazione massima 25%
%Mr = 1.39 --> 2.86db
%margine di fase da Nichols circa 42
%margine di fase dalla formula 45.7

Ga = Kc/Kr * F1 * F2
figure,bode(Ga)
%aumentiamo Kc per avere un modulo accettabile

%rete anticipatrice
md = 3
xd = 0.8
taud = xd/wcd
Rd = (s*taud+1) / (s*taud/md+1)

Ga2 = Ga * Rd^2

[m,f]=bode(Ga2,wcd)

figure,margin(Ga2)
C = Kc * Rd^2
W = feedback(C*F1*F2,1/Kr)
figure,step(W)
figure,bode(W)

wb = 37.1
%tempo di salita
%ts = 0.0831

%picco di risonanza
%Mr = 1.83

%errore di inseguimento massimo ad un sin(0.2t)
sens = feedback(1,Ga2)
errsin = bode(sens,0.2)


%discretizzazione
T = 2*pi/(20*wb)
Gazoh = Ga2 /(1+T/2*s)
figure,margin(Gazoh)
%il margine è accettabile
Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')

%sovraelongazione migliore con tustin