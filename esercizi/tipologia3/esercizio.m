clear all
close all

s = tf ('s')
F = -0.65 / (s^3 + 4*s^2 + 1.75*s)
Tp = 1
A = 9

Kf = dcgain(s*F)
d1 = 5.5e-3 %valore massimo
%d2 = 5.5e-3 * t
%dp = 10e-3*sin(30t)

%NO poli nel controllore

%specifiche statiche

%errore di inseguimento alla rampa < 0.1
Kc1 = 1/(Tp^2*A*Kf*0.2)

%disturbo d1 < 6e-4
% d1 / (Kc * A * Tp) < 6e-4
Kc2 = d1 / (A * Tp * 6e-4)

%disturbo d2 < 1.5e-3
% d1 / (Kc * Kf * Tp * A ) < 1.5e-3
Kc3 = d1 / (Kf*Tp*A*1.5e-3)

%I VALORI DI KC VENGONO PRESI IN MODULO IL PIU STRINGENTE E' KC1

Kc = 1.4957

% studio del segno di kc

figure,nyquist (A*F)

%scegliamo k negativo

Kc = -1.5


%analisi specifiche dinamiche

%tempo di salita < 1
%wb >= 3/ts = 3
%wcd = 0.63 * wb = 1.89

wcd = 1.9

%sovraelongazione < 30%
%Mr = 1.44 --> 3.17db
%margine di fase da Nichols = 40 gradi
%margine di fase da formula = 44 gradi

Ga = Tp * Kc * A * F
figure,bode (Ga)

%rete anticipatrice

md = 4
xd = 1
taud = xd/wcd
Rd = (s*taud+1) / (s*taud/md+1)
Ga2 = Ga * Rd^2

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 1.1
bode((1+s/mi) / (1+s))
xi = 20
taui = xi / wcd
Ri = (s*taui/mi+1) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc * Rd^2 * Ri

W = feedback ( C * F * A,Tp)
figure,step (W)

%specifiche statiche soddisfatte

%valutazione parametri
%valutiamo la banda passante e picco di risonanza
figure,bode(W)
%3.45, 2.38
wb = 3.45
%%il valore massimo del comando che può essere indotto in regime permanente
%dal disturbo dp = 10e-3*sin(30t) posto nella retroazione

sens = feedback(1,Ga3)
umax = bode(-C*sens,30)

%discretizzazione
T = 2*pi/(20*wb)
T = 0.03
Gazoh = Ga3/(1+s*T/2)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')

%scegliamo zoh perchè ha migliore tempo di salita e sovraelongazione