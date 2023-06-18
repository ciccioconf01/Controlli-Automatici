clear all
close all
s = tf('s');
F = (4*s^2 + 1200*s+90000) / (s^3 + 154*s^2 + 5600*s + 20000)
N = 10
%controllo soluzione anello chiuso

[Gm,Pm,Wgm,Wpm] = margin(F)

%gm è infinito --> non è possibile utilizzare la soluzione in anello chiuso


%controllo soluzione anello aperto
figure,step(F)

Kf = 4.5

val = 0.63 * Kf %2.835
%la funzione vale 2.835 all'istante 0.265

tetaf = 0.025
tauf = 0.24

Fapp = (Kf * exp(-tetaf*s))/ (1+tauf*s) 
hold on
step(Fapp)
hold off

Kp = (1.2*tauf) / (Kf * tetaf)
Ti = 2*tetaf
Td = 0.5*tetaf

Rpid = Kp * (1+1/(Ti*s) + (Td*s) / (1+Td/N*s))

Ga = F * Rpid
figure,margin(Ga) %margine di fase 63 gradi

W = feedback(Ga,1)
figure,step(W) % sovraelongazione 20.%
%tempo di salita 0.0462


