clear all
close all
s = tf('s')
F = (10*(s+10)) / (s^2+0.5*s+25)

d1 = 1
d2 = 1%t
% d3 = sin(1000t)

Kf = dcgain(F)

%dobbiamo aggiungere un polo nel controllore

%specifiche statiche
%errore di inseguimento alla rampa < 1.25e-4

Kc1 = 1 / (1.25e-4*Kf)

%effetto del disturbo d2 < 2.5e-4
Kc2 = 1/(2.5e-4*Kf)

Kc = 2000

%studio del segno di Kc
%Kf1 > 0 --> ok
%tutti i poli Re<0 --> ok
bode(F/s)
% un solo attraversamento a 0db e -180 gradi --> ok

%segno positivo

%analisi specifiche dinamiche

%tempo di salita circa 0.04 (0.032 < ts < 0.048)
%wb = 3/ts = 75
%wcd = 0.63 * wb = 47.25

%scelgo ts 0.045
wcd = 42

%sovraelongazione massima < 35%
%Mr = (1+s_hat) / 0.9 = 1.5 --> 3.52 db
%margine di fase da Nichols circa 38 gradi
%margine di fase da formula 42.4 gradi
%scegliamo 43 gradi

Ga1 = Kc/s * F

figure,bode (Ga1)
%abbiamo 19.3db di modulo e -191 di fase

%dobbiamo recuperare almeno 62 gradi

%rete PI
figure,bode(1+s)

xz = 2.83
tauz = xz / wcd
Rz=(1+tauz*s);

Ga2 = Ga1 * Rz
[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 35.5
figure,bode ( (1+s/mi) / (1+s))
xi = 350
taui = xi/wcd
Ri = (1+s*taui/mi) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc/s * Rz * Ri

W = feedback (C*F,1)

figure,step(W)
figure,bode(W)

%calcolo parametri

%banda passante
wb = 61.3

%errore di inseguimento massimo per r(t) = sin(0.5t)
sens = feedback (1,Ga3)
errsens = bode(sens,0.5)

%valore massimo del comando avente distrurbo d3 = sin(1000t)
umax = bode(-C*sens,1000)

%discretizzazione
T = 2*pi/(20*wb)

Gazoh = Ga3/(1+s*T/2)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz2 = c2d(C,T,'match')

