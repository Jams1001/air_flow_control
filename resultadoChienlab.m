
data = readmatrix('pruebaChien.xlsx','Range','A1:D2188')
%data = readmatrix('Flujo_delta_25a50_sin_ruido.xlsx')

%data = readmatrix('Flujo_delta_25a50.xlsx')


t = data(:,1);
r = data(:,2);
y = data(:,3);
u = data(:,4);

tn = t - mean(t(1:10));
yn = y - mean(y(1:10));
rn = r - mean(r(1:10));
un = u - mean(u(1:10));

figure(1);
plot(tn, rn, 'r', tn, yn, 'g',tn, un, 'b');
xlabel ('Tiempo (s)') ;
ylabel ('Amplitud') ;
title("Respuesta del sistema con datos reales ajustados - Chien ")
legend ('r(s)','y(s)','u(s)') %leyenda
grid on;



% Parámetros

% Para realizar el cálculo de parámetros es necesario utilizar los vectores
% normalizados.

% Error permanente promedio
Eprem = mean(abs(rn-yn))

% Se obtiene el sobrepaso máximo no normalizado para luego comparar con el
% valor máximo y normalizar el sobrepaso.
[Ymax1, indymax1] = max(yn,[],'all')

% Valor final de la respuesta: utilizo el promedio de los últimos 851 datos
Yf1 = mean(yn(1337:2188))

% Máximo de la señal realimentada 
Ymax = max(abs(max(yn)),abs(min(yn)))

% Sobrepaso máximo normalizado
Mpnr = 100*(Ymax1-Ymax)/(Ymax)

% Posición del vector de respuesta cuando llega a la banda del 2%
% Busca el índice del valor que es mayor al 2% del valor mááximo de la
% señal realimentada y se le resta uno.
ind2per = find(yn>Ymax-0.02*(Ymax),1)-1

% Tiempo de asentamiento al 2%
% Busca en el vector del tiempo el índice del dato asociado al 2%
t2per1 = tn(ind2per)

% IAE
IAE = trapz(tn,abs(rn-yn))


% Esfuerzo de control
TVur = sum(abs(diff(un)))

