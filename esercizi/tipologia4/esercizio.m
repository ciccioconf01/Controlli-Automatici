clear all
close all

s = tf('s')
F1 = 5/s
F2 = (s+20) / ((s+1)*(s+5)^2)
Kr = 1
d1 = 0.5
d2 = 0.1%*t

Kf1 = dcgain(s*F1)
Kf2 = dcgain(F2)

%NON dobbiamo inserire poli nell'origine

%e < 0.05
Kc1 = Kr^2 / (Kf1*Kf2*0.05)
Kc1 = 5

%d2 < 0.01
Kc2 = (0.1*Kr)/(0.01 * Kf1 *Kf2)
Kc2 = 2.5

%prendiamo kc = 5
Kc = 5

%studio del segno di Kc
%prodotto di Kf1*Kf2 positivo --> ok
%tutti i poli sono a parte reale negativa

figure,bode(F1*F2)
%un solo attraversamento per 0db e -180 gradi

%segno positivo

%analisi specifiche dinamiche 

%tempo di salita circa 1 secondo (0.8<ts<1.2)
%wb = 3/ts = 3
%wcd = 0.63 * 3 = 1.89
wcd = 1.89

%picco di risonanza non superiore a 2.5
%margine di fase circa 42 gradi da Nichols
%margine di fase dalla formula = 47.5

Ga1 = Kc * 1/Kr * F1 * F2
figure,bode(Ga1)

%recuperiamo dai 60 ai 65 gradi

%rete anticipatrice
%scegliamo 2 reti da 4 centrate in 1
md = 4
xd = 1
taud = xd/wcd
Rd = (s*taud+1) / (s*taud/md+1)

Ga2 = Ga1 * Rd^2
[m,f] = bode (Ga2,wcd)

%rete attenuatrice
mi = 8.1
figure,bode ((1+s/mi)/(1+s))
xi = 120
taui = xi / wcd
Ri = (s*taui/mi+1) / (s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc * Rd^2 * Ri
W = feedback(C*F1*F2,1/Kr)

figure,step(W)
figure,bode(W)

%specifiche dinamiche soddisfatte

%valutazione parametri

%banda passante
wb = 3.72

%sovraelongazione massima
%s_hat = 22%


%attività sul comando quando r(t) = 1 (gradino unitario)

Wu = C * feedback(1,Ga3);
figure,step(Wu,0.2)

%guardiamo il peakResponse -> 9.88

%discretizzazione 

T = 2*pi / (20 * wb)
T = 0.02

Gazoh = Ga3 / (1+s*T/2)
figure,margin(Gazoh)

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')

%match e tustin sono i migliori in termini di sovraelongazione , invece zoh
%è migliore in termini di tempo di salita