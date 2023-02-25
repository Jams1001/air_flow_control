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
plot(t, un, 'r', t, yn, 'g');


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

% Murril sin compensar
%sisotool(C3)
%figure(2)
%margin(L1)
%grid on

Myr = L/(1+L)

yc = lsim(Myr, un, t);

figure(3)
plot(t, un, t, yc,"LineWidth", 1.5)
hold on
grid on
legend('Entrada', 'Salida')
title("Respuesta controlador Murril")
xlabel("Tiempo (s)")
ylabel("Amplitud")
hold off


%IAE
IAE = trapz(t, abs(un-yc))

