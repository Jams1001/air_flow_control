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

sisotool(C3)
bode(L1)
margin(L1)
grid on
figure(1)




% Parte III: obtención de parámetros

% Se realiza la simulación de esta forma para poder calcular parámetros
% Si se utilizan los tiempos de simulación de la parte anterior, se
% presenta un error debido a que la cantidad de elementos en vectores no
% coincide.


Myr= L1/(1+L1);

y1=lsim(Myr,un,tp);


plot(tp,un,tp, y1,"LineWidth",1.5)
hold on
grid on
legend("entrada","y(t) ")
title("Respuesta realimentada controlador Chien")
xlabel("Tiempo (s)")
ylabel("Amplitud")
figure(2)
hold off



% IAE

% Se debe tratar más debido a que el error se está calculando utilizando el
% valor deseado, no la  salida de la planta.

% Para poder calcularlo, ES NECESARIO SIMULAR LA RESPUESTA DE LA PLANTA
% sin compensar para poder calcular el error y así poder integrarlo.

SalidaPlanta= un;
SalidaModelo= y1; % Obtenido con toolbox
e_IAE=abs(SalidaPlanta-SalidaModelo);
IAE=trapz(tp,e_IAE)




