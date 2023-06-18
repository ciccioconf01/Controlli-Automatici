clear all
close all
s = tf('s')

A = 0.1
F = (s-20) / (s*(s+10))

Kf = dcgain(s*F)
d1 = 0.1
d2 = 0.2

%si deve aggiungere un polo nel controllore

Kc = 1 / (0.5*A*Kf)


Kc = 10

figure,nyquist(F)

Kc = -10

%analisi specifiche dinamiche
 wb = 2.5 % (2.25<wb<2.75)
 wcd = 1.58
 
 %Mr <= 3.5db 
 %margine di fase 42.5
 
Ga = Kc/s * A * F
 
figure,bode(Ga)
 
%rete PI
figure,bode(1+s)
xz = 2
tauz = xz/wcd
Rpi = 1+tauz*s

Ga2 = Ga * Rpi

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 1.77
figure,bode((1+s/mi)/(1+s))
xi = 50
taui = xi/wcd
Ri = (s*taui/mi+1) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc/s * Rpi * Ri 

W = feedback(C*A*F,1)
figure,step(W)
figure,bode(W)

%specifiche soddisfatte