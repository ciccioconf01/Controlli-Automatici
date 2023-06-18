clear all
close all
s = tf('s')
F1 = 30 / (s+15)
F2 = (3*s + 3) / (s^3 + 10*s^2 + 24 *s)
Kr = 1
d1 = 1
d2 = 4

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

% NON dobbiamo mettere poli nel controllore

% errore di inseguimento alla rampa < 0.1
% Kr/Kga < 0.1
% Kr^2 / (Kc * Kf1 * Kf2) < 0.1
% Kc > Kr^2 / (0.1 * Kf1 * Kf2)
Kc1 = 40

%effetto del disturbo d1 < 0.05
% d1 / Kg1 < 0.05
% (d1 * Kr) / (Kc * Kf1) < 0.05
% Kc > (d1*Kr) /(0.05*Kf1)
Kc2 = 10

Kc = 40

%studiamo il segno di Kc
%tutti i poli devono essere a RE<0
%Kf1 e Kf2 concordi
bode(F1*F2)
% un solo attraversamento a 0db e a -180 gradi

%segno positivo


%analisi specifiche dinamiche

%banda passante circa 20 ( specifica soddisfatta se 18<wb<22)
wb = 20
wcd = 0.63 * 20
wcd = 13

%sovraelongazione massima < 20%
% Mr = (1+s_hat) / 0.9 = 1.3 --> 2.28db
% margine_fase = 60 - 5 * Mr = 49 gradi

Ga1 = 1/Kr * Kc * F1 * F2
figure,bode(Ga1)


%dobbiamo recuperare 53 gradi, decidiamo di recuperare 60 gradi a causa
%della rete attenuatrice da inserire in seguito

%scegliamo di prendere 2 reti da 4 centrate in 1
md = 4
xd = 0.9
taud = xd/wcd
Rd = (s*taud+1) / (s*taud/md+1)
Ga2 = Ga1 * Rd^2

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 1.6
bode((1+s/mi)/(1+s))
xi = 25
taui = xi/wcd
Ri=(s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc * Rd^2 * Ri

W = feedback(C*F1*F2 , 1/Kr)
figure,step(W)
figure,bode(W)

wb = 21.7
%se siamo sopra la banda passante conviene ridurre il margine di fase se
%possibile oppure ridurre wcd

%specifiche dinamiche soddisfatte

%verifiche specifiche statiche con simulink

%parametri aggiuntivi

%tempo di salita : %faccio step(W) e guardo quando il grafico interseca la
%prima volta 1 --> 0.15 sec

%picco di risonanza della risposta in frequenza --> diagramma del modulo,
%peak response --> 0.969

%errore di inseguimento a sin(0.2t)

sens = feedback (1,Ga3)
errsens = bode (sens,0.2)


%discretizzazione

T = 0.01

Gazoh = Ga3/(1+s*T/2)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')





