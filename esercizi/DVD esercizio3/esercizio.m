clear all
close all
s = tf('s')

F1 = (s+40) / (s+2)
F2 = 80 / (s^2+13*s+256)
Kr = 1
d1 = 0.5
d2 = 0.2

Kf1 = dcgain(F1)
Kf2 = dcgain(F2)

%dobbiamo inserire un polo nel controllore
Kc = Kr / (0.04*Kf1*Kf2)

%studio segno
%Kf1*Kf2 positivo --> ok
%tutti i poli re<0 --> ok
bode(F1*F2/s)
% un solo attraversamento 0db e -180 gradi
%segno positivo

Kc = 4

%analisi specifiche dinamiche
%ts = 0.2 (0.16 < ts < 0.24)
%wb = 15
wcd = 9.45

%sovraelongazionw minore 35%
%Mr = 1.5 --> 3.52db
%margine di fase 42.5

Ga = Kc/s * F1 * F2
figure,bode(Ga)
%dobbiamo recuperare 53.5 gradi, il modulo è -3.14
%rete PI
figure,bode(1+s)
xz = 2.3
tauz = xz/wcd
Rz = 1+tauz*s

Ga2 = Ga*Rz
[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 1.74
figure,bode((1+s/mi)/(1+s))
xi = 40
taui = xi/wcd
Ri = (s*taui/mi+1) / (s*taui+1)
Ga3 = Ga2 * Ri

figure,margin(Ga3)
C = Kc/s * Rz * Ri

W = feedback(C*F1*F2,1)
figure,step(W)

%specifiche soddisfatte

%calcolo parametri
%banda passante e picco di risonanza
figure,bode(W)
%Mr = 3.41db
wb = 18.7

%valore massimo del comando con r(t) = 1
sens = feedback(1,Ga3)
figure,step(C*sens)

%discretizzazione
T = 2*pi/(20*wb)
Gazoh = Ga3 / (1+T/2*s)
figure,margin(Gazoh)
Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')