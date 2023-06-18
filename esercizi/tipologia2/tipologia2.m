clear all 
close all

s = tf ('s');
F1 = (1+s/0.1) / ((1+s/0.2)*(1+s/10))
F2 = 1/s
Kr = 1
d = 1.5

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

%dobbiamo aggiungere un polo nel controllore per rendere finito l'errore
%dato che il riferimento è una parabola

%e < 0.16
%Kr/Kga < 0.16
% Kr^2/(Kc*Kf1*Kf2) < 0.16
% Kc > Kr^2 / (0.16*Kf1*Kf2)
Kc = 6.25

%segno di Kc
%tutti i poli con parte reale < 0 --> ok
%prodotto di Kf1*Kf2>0 --> ok
bode(F1*F2/s)
%un solo attraversamento in 0db e -180 gradi

%scelgo il segno positivo

%specifiche dinamiche
%banda passante circa 4 (specifica sodd. se 3.6<wb<4.4) 
wb = 4
wcd = 2.5

%sovraelongazione massima minore 25%
%Mr = 1.4 --> 2.92 db
%margine di fase minimo 46 gradi

Ga1 = Kc/s * F1 * F2
bode(Ga1)
%recuperiamo circa 65 gradi

%inserimento di uno zero reale insieme al polo
bode(1+s)
%alle frequenza di 2.15 si recuperano 65 gradi
xz = 2.75
tauz = xz / wcd
Rz=(1+tauz*s);

Ga2 = Ga1 * Rz
[m,f] = bode (Ga2,wcd)

%rete attenuatrice
mi = 5.6
bode ( (1+s/mi) / (1+s))
xi = 100
taui = xi/wcd
Ri = (1+s*taui/mi) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc/s * Rz * Ri
W = feedback (C * F1 * F2,1/Kr)
figure,step(W)
figure,bode(W)

wb = 4.01
%valutazione parametri
%tempo di salita
ts = 0.64

%picco di risonanza
Mr = 2.27

%attività sul comando quando r(t) = 1 (gradino unitario)
Wu = C * feedback(1,Ga3)
figure,step(Wu,0.2)

%dicretizzazione
T = 2*pi / (20 * wb)

Gazoh = Ga3 / (1+s*T/2)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')
