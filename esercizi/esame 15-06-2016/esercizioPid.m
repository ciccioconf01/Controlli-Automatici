clear all
close all
s = tf('s')

F = 400 * (3-s) / ((s+1)^2*(s+4)^2*(s+10))

[Gm,x,Wgm,y] = margin(F)
%gm finito --> anello chiuso
N = 20

Kpbar = Gm
Tbar = 2*pi/Wgm

Kp = 0.6*Kpbar
Ti = 0.5*Tbar
Td = 0.125*Tbar

Rpid = Kp*(1+1/(Ti*s)+(Td*s)/(1+Td/N*s))

Ga = Rpid * F

figure,margin(Ga)

W = feedback(Ga,1)

damp(W)

figure,step(W)
figure,bode(W)