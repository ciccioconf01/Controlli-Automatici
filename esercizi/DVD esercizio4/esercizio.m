clear all
close all
s = tf('s')

F1 = 5/s
F2 = (s+20) / ((s+1)*(s+5)^2)
Kr = 1
d1 = 0.5
d2 = 0.1%t

Kf1 = dcgain(s*F1)
Kf2 = dcgain(F2)

%Non c'è bisogno di poli

Kc1 = Kr / (0.05*Kf1*Kf2)

Kc2 = 0.1 / (Kf1*Kf2*0.01)

Kc = 5

%segno
%Kf1 e Kf2 concordi
%poli re<0
figure,bode(F1*F2)
%segno positivo

%ts = 1 (0.8 < ts < 1.2)
%wb = 3
wcd = 1.89

%margine di fase 47.5

Ga = Kc * F1 * F2

figure,bode(Ga)

%recuperiamo almeno 62 gradi

%rete anticipatrice 2 reti da 4 in 1
md = 4
xd = 1
taud = xd / wcd
Rd = (s*taud+1) / (s*taud/md+1)

Ga2 = Ga * Rd^2

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 8.19
bode((1+s/mi)/(1+s))
xi = 150
taui = xi/wcd
Ri = (s*taui/mi+1) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc * Rd^2 * Ri

W = feedback(C * F1 * F2,1)
figure,step(W)
figure,bode(W)

%il valore massimo del comando quanto R(t) = 1
sens = feedback(1,Ga3)
figure,step(C*sens)