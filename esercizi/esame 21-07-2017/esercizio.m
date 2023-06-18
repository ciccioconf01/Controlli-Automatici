clear all
close all

s = tf('s')
F = 8*(s+15) / (9*s*(s+1)*(s^2+s+100))

Kf = dcgain(s*F)

%dobbiamo inserire un polo nel controllore

%3/kga < 45
Kc = 3/(Kf*45)
Kc = 0.50

%positivo

%analisi specifiche dinamiche
%ts circa 4 (3.8 < ts < 4.2)
%wb = 0.75
wcd = 0.45

%sovraelongazione < 30%
%Mr = 3.19db
%margine di fase = 44

Ga = Kc/s * F
figure,bode(Ga) %68 gradi da recuperare e 11.3 db

%due reti PI
figure,bode(1+s)
xz = 3.5
tauz = xz/wcd
Rz = 1+tauz*s

Ga2 = Ga*Rz
[m,f] = bode(Ga2,wcd)

figure,margin(Ga2)

C = Kc/s * Rz
W = feedback(C*F,1)
figure,step(W)
figure,bode(W)
