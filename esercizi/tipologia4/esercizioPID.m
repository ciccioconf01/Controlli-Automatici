clear all
close all

s = tf('s')
F = (3*s+6) / (s^4 + 6.5*s^3 + 12*s^2 + 4.5*s)
N = 10

%valutare banda passante e picco di risonanza
%controllo soluzione anello chiuso

[Gm,Pm,Wgm,Wpm] = margin(F)

%Gm finito --> soluzione anello chiuso

Kpbar = Gm
Tbar = 2*pi/Wgm

Kp = 0.6 * Kpbar
Ti = 0.5 * Tbar
Td = 0.125 * Tbar

Rpid = Kp * (1+1/(Ti*s)+(Td*s)/(1+Td/N*s))


Ga = F*Rpid

figure,margin(Ga)

W = feedback(Ga,1)
figure,bode(W)

%picco di risonanza 9.72
%banda passante 2.18

