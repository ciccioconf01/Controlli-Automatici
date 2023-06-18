clear all
close all
s = tf('s')

F1 = (1+s/0.1) / ((1+s/0.2) * (1+s/10))
F2 = 1/s
Kr = 1
d = 1.5
Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

%un polo nel controllore

Kc1 = Kr / (0.16*Kf1*Kf2)
Kc = 6.25

%Kf1 e Kf2 concordi
% tutti i poli a parte reale negativa
figure,bode(F1*F2/s)
% un solo attraversamento

%positivo 

%analisi specifiche dinamiche

%wb = 4 (3.6<wb<4.4)
wcd = 2.52

%sovraelongazione < 25%
%Mr = 2.85db
%margine di fase = 45.75 gradi

Ga = Kc/s * F1 * F2
figure,bode(Ga)

%recuperiamo 64 gradi

%rete PI
figure,bode(1+s)
xz = 3.45
tauz = xz/wcd
Rz = 1+tauz*s

Ga2 = Ga * Rz

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 6.84
figure,bode((1+s/mi)/(1+s))
xi = 65
taui = xi/wcd
Ri = (s*taui/mi+1) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)
C = Kc/s * Rz * Ri

W = feedback(C*F1*F2,1)
figure,step(W)
figure,bode(W)
wb = 4.01

%altri parametri
%ts = 0.641
%Mr = 2.24

% valore massimo del comando con r(t) = sin(0.5t)
sens = feedback(1,Ga3)
err = bode(C*sens,0.5)

%discretizione
T = 2*pi/(20*wb)
Gazoh = Ga3 / (1+T/2*s)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')