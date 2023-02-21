clc;
clear;
close all;

% Carga de datos
data = readmatrix('Flujo_delta_25a50.xlsx','Range','A377:C1471')
%data = readmatrix('Flujo_delta_25a50_sin_ruido.xlsx')

%data = readmatrix('Flujo_delta_25a50.xlsx')


t = data(:,1)-30;
u = data(:,2);
y = data(:,3);


yn = y - mean(y(1:10));
un = u - mean(u(1:10))

%figure(1);
%plot(t, un, 'r', t, yn, 'g');


s = tf("s");
% Datos de la plata
%P1=(0.9058*exp(-0.11419*s))/(1+1.2637*s)
Kp = 0.9058;
L = 0.11419; % Td
T = 1.2637; % Tp1
a = 0;      % a se encuentra dentro del rango
tao = L/T % tao se encuentra dentro del rango


% Planta
P=(Kp*exp(-L*s))/(1+T*s)

% Controlador Reswick
%{
Kc = 0.15/Kp
Ti2 = 0.16*tao
C3 = Kc* (( Ti2*s + 1)/(Ti2*s))
%}

% Controlador Chien

Kc = (0.35*T)/(Kp*L)
Ti2 = 1.17*T
C3 = Kc* (( Ti2*s + 1)/(Ti2*s))
L = P*C3

sisotool(C3)
figure(1);
bode(L)
margin(L)
grid on

% Pruebas con controlador Shinskey

t = [0:0.01:100];
% Servocontrol
Myr = ( C3 * P ) /(1+ C3 * P );
% Regulador
Myd = minreal( P /(1+ C3 * P ) ); 

r = 0; %referencia
r ( t >= 1) = 1;

% La perturbacipón pasa de 0 a 0.5 cuando el tiempo es mayor o igual a 70.
d = 0; %perturbacion
d ( t >= 25) = 0;

% Para simular el servocontrol
yr = lsim ( Myr , r , t );
% Para simular el regulador
yd = lsim ( Myd , d , t );
y = yr + yd;

figure (2) ;
title ('Respuesta del sistema como Servocontrol y como Regulador ') ;
plot (t,d,'--',t,y,t,r)
xlabel ('Tiempo (s)') ;
ylabel ('Respuesta del sistema ') ;ylabel ('Respuesta del sistema ') ;
legend ('d(s)','y(s)','r(s)') %leyenda
grid on;


