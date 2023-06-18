clear all
close all
s = tf('s')
F = (4*s^2+1200*s+90000) / (s^3+154*s^2+5600*s+20000)

[Gm,a,Wgm,b] = margin(F)

figure,step(F)
Kf = 4.5 %63% --> 2.835 --> 0.267

tauf = 0.2
tetaf = 0.067

Fapp = Kf * exp(-tetaf*s) / (1+tauf*s)
hold on
step(Fapp)
hold off

Kp = 1.2*tauf/(Kf*tetaf)
Ti = 2*tetaf
Td = 0.5*tetaf
N=10
pc = -N/Td
Rpid = Kp*(1+1/(Ti*s)+Td*s/(1+Td/N*s))

Ga = F * Rpid
figure,margin(Ga)

W = feedback(Ga,1)
figure,step(W)