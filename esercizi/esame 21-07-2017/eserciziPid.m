clear all
close all

s = tf('s')

F = 5000 / ((s+1)^2*(s^2+10*s+25)*(s^2+16*s+100))
N = 20

[Gm,a,Wgm,b] = margin(F)

figure,step(F)
%la risposta al gradino è asintoticamente stabile
%F è stabile
%posso utilizzare il metodo in catena aperta

Kf = 2
ventiseiPercento = 1.26

tauf = 1.6
%tetaf +tauf = 2.72
tetaf = 1.12

Fapp = (Kf * exp(-tetaf*s))/ (1+tauf*s)
hold on
step(Fapp)
hold off

Kp = 1.2*tauf/(Kf*tetaf)
Ti = 2*tetaf
Td = 0.5*tetaf

Rpid = Kp * (1+1/(Ti*s) + (Td*s) / (1+Td/N*s))

Ga = Rpid * F
figure,margin(Ga)
W = feedback(Ga,1)
figure,step(W)
figure,bode(W)