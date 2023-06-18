clear all
close all

s = tf('s')
F = 2*(s+10) / (s*(s+1)*(s+8)^2)

[Gm,a,Wgm,b] = margin(F)

Kpbar = Gm
Tbar = 2*pi/Wgm

Kp = 0.6*Kpbar
Ti = 0.5*Tbar
Td = 0.125*Tbar
N = 10
pc = -N/Td 
Rpid = Kp*(1+1/(Ti*s)+Td*s/(1+Td/N*s))
Ga = F * Rpid
figure,margin(Ga)

W = feedback(Ga,1)
figure,bode(W)