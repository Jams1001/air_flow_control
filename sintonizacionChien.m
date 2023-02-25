clc;
clear;
close all;

% Parte I: Carga de datos
% Se utiliza para observar el comportamiento real de la planta
% No se utiliza para nada más

% Carga de datos
data = readmatrix('Flujo_delta_25a50.xlsx','Range','A377:C1471')
%data = readmatrix('Flujo_delta_25a50_sin_ruido.xlsx')

%data = readmatrix('Flujo_delta_25a50.xlsx')


tp = data(:,1)-30;
u = data(:,2);
y = data(:,3);


yn = y - mean(y(1:10));
un = u - mean(u(1:10))

%figure(1);
%plot(t, un, 'r', t, yn, 'g');


% Parte II: Simulación de respuesta de sistema con controlador Chien

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

% Controlador Chien

Kc = (0.35*T)/(Kp*L)
Ti2 = 1.17*T
C3 = Kc* (( Ti2*s + 1)/(Ti2*s))
L1 = P*C3

%sisotool(C3)
%figure(1);
%bode(L)
%margin(L)
%grid on




% Pruebas con controlador Chien

% Vector de tiempo para respuesta de sistema simulado. NO CONFUNDIR CON
% VECTOR DE TIEMPO utilizado para calcular parámetros

t = [0:0.01:100];
% Servocontrol
Myr = ( C3 * P ) /(1+ C3 * P );
% Regulador
Myd = minreal( P /(1+ C3 * P ) ); 

% F.T de la planta: Se hizo para tratar de simular la respuesta de la
% planta, sin embargo, no se ha podido simular la respuesta de la planta.
Myrp = ( P ) /(1+ P );
 
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


%figure (2) ;
%title ('Respuesta del sistema como Servocontrol y como Regulador ') ;
%plot (t,d,'--',t,y,t,r)
%xlabel ('Tiempo (s)') ;
%ylabel ('Respuesta del sistema ') ;ylabel ('Respuesta del sistema ') ;
%legend ('d(s)','y(s)','r(s)') %leyenda
%grid on;

% Parte III: obtención de parámetros

% Se realiza la simulación de esta forma para poder calcular parámetros
% Si se utilizan los tiempos de simulación de la parte anterior, se
% presenta un error debido a que la cantidad de elementos en vectores no
% coincide.

Myr= L1/(1+L1);
r2=heaviside(t-1);ss
r1 = r2*25;
y1=lsim(Myr,r1,t);

%{
% Salida planta
yp = lsim (Myrp , r , t )
%}

%yplanta = lsim(Myrp,r,t);

plot(t,r1,t, y1,"LineWidth",1.5)
hold on
grid on
legend("entrada","y(t) ")
title("Respuesta realimentada controlador Chien")
xlabel("Tiempo (s)")
ylabel("Amplitud")
figure(1)
hold off

%{
plot(t,r,t, yplanta,"LineWidth",1.5)
hold on
grid on
legend("entrada","y(t) ")
title("Salida de planta")
xlabel("Tiempo (s)")
ylabel("Amplitud")
figure(2)
hold off
%}


% IAE

% Se debe tratar más debido a que el error se está calculando utilizando el
% valor deseado, no la  salida de la planta.

% Para poder calcularlo, ES NECESARIO SIMULAR LA RESPUESTA DE LA PLANTA
% sin compensar para poder calcular el error y así poder integrarlo.

SalidaPlanta= r1;
SalidaModelo= y1; % Obtenido con toolbox
e_IAE=abs(SalidaPlanta-SalidaModelo);
IAE=trapz(t,e_IAE)


