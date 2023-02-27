clc;
clear;
close all;

% Carga de datos
data = readmatrix('Flujo_delta_25a50.xlsx','Range','A377:C1471')

t = data(:,1);
u = data(:,2);
y = data(:,3);

yn = y - mean(y(1:10));
un = u - mean(u(1:10))

figure(1);
hold on
plot(t, un, 'r', t, yn, 'g');
hold off


s = tf('s');


% Datos de la plata
Kp = 0.9058;
L = 0.11419;
T = 1.2637; 
a = 0;      
tao = L/T 

P = (Kp*exp(-L*s))/(1+T*s)


% Controlador Murril
Kc = (0.928/Kp)*(L/T)^(0.946)
Ti = (T/1.078)*(L/T)^(0.583)
C = Kc* (( Ti*s + 1)/(Ti*s))
L = P*C


Myr = L/(1+L)

yc = lsim(Myr, un, t);

% Murril 
%sisotool(C)
bode(L)
margin(L)
grid on


figure(2)
plot(t, un, t, yc, "LineWidth", 1.5)
hold on
grid on
legend('Entrada', 'Salida')
title("Respuesta controlador Murril")
xlabel("Tiempo (s)")
ylabel("Amplitud")
hold off


%IAE
IAE = trapz(t, abs(un-yc))


%tiempo de asentamiento
ind = find(yc > max(yc)-0.02*(max(yc)),1)-1;
ta2 = t(ind) 

M = minreal(-(C*P) / (1 + C*P));
u = lsim(M, d, t);
TVud = sum(abs(diff(u)))

