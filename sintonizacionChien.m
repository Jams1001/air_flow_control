clc;
clear;
close all;

data = readmatrix('Flujo_delta_25a50.xlsx','Range','A377:C1471');

tp = data(:,1);
u = data(:,2);
y = data(:,3);


yn = y - measisotool(C3);
bn(y(1:10));
un = u - mean(u(1:10))


s = tf("s");
Kp = 0.9058;
L = 0.11419; 
T = 1.2637;
a = 0;     
tao = L/T 


% Planta
P=(Kp*exp(-L*s))/(1+T*s)

% Controlador Chien
Kc = (0.35*T)/(Kp*L)
Ti2 = 1.17*T
C3 = Kc* (( Ti2*s + 1)/(Ti2*s))
L1 = P*C3

sisotool(C3);
bode(L1);
margin(L1);
grid on

Myr= L1/(1+L1);
y1=lsim(Myr,un,tp);

figure(1)
plot(tp,un,tp, y1,"LineWidth",1.5)
hold on
grid on
legend("entrada","y(t) ")
title("Respuesta de sistema controlador Chien")
xlabel("Tiempo (s)")
ylabel("Amplitud")
figure(2)
hold off



% IAE
SalidaPlanta= un;
SalidaModelo= y1;
e_IAE=abs(SalidaPlanta-SalidaModelo);
IAE=trapz(tp,e_IAE)