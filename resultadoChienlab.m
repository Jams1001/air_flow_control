data = readmatrix('pruebaChien.xlsx')
%data = readmatrix('Flujo_delta_25a50_sin_ruido.xlsx')

%data = readmatrix('Flujo_delta_25a50.xlsx')


t = data(:,1);
r = data(:,2);
y = data(:,3);
u = data(:,4);


yn = y - mean(y(1:10));
rn = r - mean(r(1:10));
un = u - mean(u(1:10));
figure(1);
plot(t, rn, 'r', t, yn, 'g',t, un, 'b');
xlabel ('Tiempo (s)') ;
ylabel ('Respuesta del sistema ') ;
legend ('r(s)','y(s)','u(s)') %leyenda
grid on;
