clear all
close all

s = tf ('s')
F = (100*s + 1000) / (s^5 + 38*s^4 + 481*s^3 + 2280*s^2 + 3600*s)
N = 10

%valutare banda passante e picco di risonanza
%controllo soluzione anello chiuso

[Gm,Pm,Wgm,Wpm] = margin(F)

Kpbar = Gm
Tbar = 2*pi/Wgm

Kp = 0.6 * Kpbar
Ti = 0.5 * Tbar
Td = 0.125 * Tbar

Rpid = Kp * (1+1/(Ti*s) + (Td * s) / (1+Td/N*s))

Ga = F * Rpid

figure,margin(Ga)

W = feedback (Ga,1)

figure,bode(W)

%banda passante 4.96
%picco di risonanza 6.91 db
