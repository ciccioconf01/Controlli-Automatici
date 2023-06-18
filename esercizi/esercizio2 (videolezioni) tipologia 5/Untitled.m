clear all
close all
s = tf('s')
F = (10*(s+10))/(s^2 + 0.5*s +25)
Kf = dcgain (F)
Kr = 1

% il sistema è di tipo 0 quindi dobbiamo mettere un polo in C per rendere
% limitato l'errore di inseguimento alla rampa e il disturbo d2

%specifiche statiche:
%errore di inseguimento alla rampa < 1,25*10^-4 --> Kr/Kga < 1,25*10-4

%effetto del disturbo d1 = 0 --> soddisfatta per il polo in C

%effetto del disturbo d2 a rampa sull'uscita <= 2,5*10^-4  --> 
% alpha/Kga <=2,5*10^-4

Kc1 = Kr/(1.25e-4 * Kf)
Kc2 = 1/(Kf * 2.5e-4)
Kc = max(Kc1,Kc2)

%scelta del segno
%Kf è positivo
%F non ha poli a parte reale positiva
%controllo i diagrammi di bode
figure,bode(F/s)
%un solo attraversamento di 0db e -180 gradi

%scelgo il segno positivo

Ga1 = Kc/s * F

%analisi specifiche dinamiche
%ts circa 0,04s  --> wb*ts = 3 --> wb=75 rad/s --> wcd=0,63*75 = 47 rad/s
wcd=44 %47 iniziale

%sovraelongazione <=35% --> Mr <= 20 log(1,35/0,9) = 3,5 db  --> da Nichols
%il margine di fase minimo è 38 gradi --> dalla formula il margine è 42,5
%gradi --> puntiamo a 43 gradi

figure,bode(Ga1)

%alla wcd la fase è -191 gradi e il modulo è 19.4 db
%dobbiamo recuperare 43 + 11  54 gradi ma dopo dobbiamo perdere modulo
%quindi recupereremo di più --> recuperimo 60 gradi

%tre possibilità: uso di reti derivatrici nel massimo, uso di reti
%derivatrici sul fronte di salita per contenere l'aumento di modulo, inserimento 
% di uno zero reale insieme al polo

%scartiamo la prima, facciamo la terza

bode(1+s)
% noto che alla pulsazione 2.2 recupero circa 65gradi dunque la scelgo

xz=2.8; %2.2 iniziale
tauz=xz/wcd;
Rz=(1+tauz*s);
Ga2 = Ga1 * Rz
[mz,fz] = bode (Ga2,wcd)
%mz = 22,6

% inseriamo adesso una rete attenuatrice
mi = 31.9 %22.6 iniziale
figure,bode((1+s/mi)/(1+s)) %devo vedere dove il modulo è piatto
%scelgo xi = 200 con perdita di fase di 6 gradi --> sopportabile
xi = 290%200;
taui = xi /wcd
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2 * Ri;
figure,margin(Ga3)
%wcd 47 --> ok
%margine di fase 48 gradi --> ok

%provo a chiudere l'anello
C = Kc/s * Rz * Ri
W = feedback (C * F,1)
figure,step(W)

% la sovraelongazione NON soddisfa le specifiche --> garantire margine di
% fase maggiore

% tempo di salita = 0.0299s --> minimo ts = 0.03 --> NON soddisfatta -->
% ridurre la wcd


%abbassiamo la wcd = 44
%cambio il valore dello zero per recuperare più fase, noto che in 2.8
%recupero 70 gradi --> provo questa soluzione
%mz diventa 31.9 cambio dunque la rete attenuatrice e cambio xi vedendo che
%alla pulsazione 290 perdo solo 6 gradi

%le specifiche sono soddisfatte


%valutare i seguenti valori

%banda passante
figure,bode (W) %cercare la frequenza a -3db --> 63.1
wb = 63.1

%calcolare l'errore di inseguimento massimo ad un segnale r(t) = sin(0.5t)
%in assenza di disturbi
sens = feedback (1,Ga3);
ersin = bode (sens,0.5) % questo è il valore

%il valore massimo del comando che può essere indotto in regime permanente
%dal disturbo d3=sin(1000t) posto nella retroazione
umax = bode (-C*sens,1000)



%discretizzazione
T = (2*pi)/(20*wb) % tempo di salita = 3centesimi , T = 5ms, è alto --> lo abbasso subito
T = 0.002

Gazoh = Ga3/(1+s*T/2)
figure,margin(Gazoh)
Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')
%passo a simulink mettendo uno step per riferimento e spegnendo i disturbi
%e guardo l'uscita

% con tutti e 3 i metodi supero il 35% di sovraelongazione --> abbasso T a
% 0.1 e noto che con tustin soddisfo la specifica



