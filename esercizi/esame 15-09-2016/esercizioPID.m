clear all
close all

s = tf('s')
F = 1/((s+1)^2*(s+4)^2*(s^2+14*s+100))

[Gm,a,Wgm,b] = margin(F)
N = 20

Kpbar = Gm
Tbar = 2*pi/Wgm

Kp = 0.6*Kpbar
Ti = 0.5 * Tbar
Td = 0.125 * Tbar

Rpid = Kp*(1+1/(Ti*s)+Td*s/(1+Td/N*s))
Ga1 = Rpid*F
figure,margin(Ga1)

W = feedback(Ga1,1)
damp(W)
figure,step(W)
figure,bode(W)