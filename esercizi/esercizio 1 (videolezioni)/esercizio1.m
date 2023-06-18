s = tf ('s');
F1 = (s+12)/(s+4);
F2 = (2*(s+5))/(s*(s^2+7.2*s+16));

Kr = 1;
d = 0.5;

% non ci vogliono poli nel controllore 
% perchè c'è già un polo nell'origine in F2 e il 
% riferimento è un gradino

% specifica1 -> disturbo <= 0.01
% ricordiamo che dipede solamente da quello che c'è a valle dunque:
% d/(kc*kf) <= 0.01 -->  kc >= d/(kf*0.01)

%specifica2 -> errore di inseguimento <= 0,1
% Kr/kga <= 0.1  --> Kr/(kc * kf1 * kf2 ) <= 0.1

Kf1 = dcgain(F1);
Kf2 = dcgain(s*F2);

Kcm1 = d/(0.01*Kf1)
Kcm2 = Kr/(0.1*Kf1*Kf2)

%Kcm1 > Kcm2

Kc = 17;

%scelta del segno
%Kf1 e Kf2 sono positivi e quindi il loro prodotto è positivo
%F1 e F2 non hanno poli a parte reale positiva
%controllo dei diagrammi di bode
bode (F1*F2)
% un solo attraversamento nell'asse 0db e -180 gradi
% il sistema è a stabilità regolare 
% scelgo il segno positivo

Ga1 = Kc * F1 * F2

%analisi delle specifiche dinamiche

%specifica1 -> modulo della funzione di sensibilità < 1 per tutte le
%pulsazioni <= 20 rad/sec
% wcd = 1.5 * 20 --> aumetare se necessario

%specifica2 -> picco di risonanza <= 2db --> margine di fase minimo da
%Nichols 46 gradi --> dalla relazione approssimata 60 - 5 * picco = 50

wcd = 30;
figure,bode (Ga1) 
%mi posiziono su 30 frequenza e leggo che bisogna recuperare 60 gradi,
%anche il modulo è da recuperare


%scelgo 2 reti anticipatrici da 4 nel massimo

md = 4;
xd = 2;
taud = xd / wcd;
Rd = (1+s*taud) / (s*taud/md + 1)

Ga2 = Ga1 * Rd^2

[m2,f2] = bode (Ga2, wcd) 
%f2 = -116.2 --> margine di fase = 180 - 116.2 = 64 ok
%m2 = 0.1618 --> troppo piccolo --> aumentare Kc

Kcorret = 1/m2
Kcorret = 8

Ga3 = Ga2 * Kcorret
figure,margin(Ga3) 
%margine di fase circa 63 e wcd circa 30 --> ok

%provo a chiudere l'anello

C = Kc * Kcorret * Rd^2
W = feedback(C*F1*F2,1)*Kr;

%controllo specifiche

%sensibilità
sens = feedback(1,Ga3)
[ms,fs]=bode(sens,20)
%ms = 0.78 < 1 in 20 rad/sec --> ok

%picco di risonanza
figure,bode(W)
%peak response = 2.31 ma doveva essere minore di 2 
%--> SPECIFICA NON SODDISFATTA
% per risolvere dobbiamo aumentare Wcd anche perchè non abbiamo
%specifiche su di essa aumentando Kc, in questo caso modificheremo
% il fattore Kcorret

% mettendo a 7 --> peakResponse = 2.1
% mettendo a 8 --> peakResponse = 1.89

% ricontrollo i parametri 
% wcd = 39.7
% margine fase = 63.8
%modulo sensibilità = 0.61 


% TUTTO OK

% ricontrollo le specifiche statiche con simulink

%per la specifica sull'uscita dato l'errore spengo la sorgente attivo il disturbo e
%controllo l'uscita  --> converge a 1.225 * 10^-3

%per la specifica sull'errore dato l'ingresso metto una rampa, spengo il
%disturbo e guardo l'errore sul comando --> converge a 3,92 * 10^-3

%specifiche statiche soddisfatte



%valutazioni in catena chiusa
%tempo di salita e sovraelongazione al gradino unitario
figure,step(W)
%tempo di salita = tempo per arrivare a 1 la prima volta -> 0.04
%sovraelongazione 15,5%

%valutazione dell'errore massimo in regime permanete con riferimento
%sin(2y)

[merr,ferr] = bode (Kr * sens,2)
%merr = 0.0093

%effetto finale sull'uscita al massimo per un disturbo sin(200t) entrante
%con ydes
[md,fd] = bode (W,200)
%md = 0.11


%discretizzazione

%ci serve la banda passante dato che non l'abbiamo
figure,bode(W)
%il modulo vale -3 a 67rad/sec

wb=67.2

T = 2*pi/(20*wb)

T = 0.004

Gazoh = Ga3 /(1+s*T/2)
figure,margin(Gazoh)
%è calato il margine di fase

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')

%vado su simulink metto step come riferimento e provo i vari controllori
%vado sull'uscita e guardo la sovraelongazione
%il migliore in termini di sovraelongazione è tustin
%posso diminuire il periodo per diminuire la sovraelongazione











