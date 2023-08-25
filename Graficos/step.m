%% Control Automático TP1 - Gráfico respuesta escalón

clear all;
clc;

cd 'C:\Users\User\Repos\TP1\'

%% Cargo función transferencia
disp('*******************************')

xi = -log(20/100)/sqrt(pi^2 + log(20/100)^2);
wn = sqrt(10^4/47);
num = [wn^2];
den = [1, 2*xi*wn, wn^2];
Gcl = tf(num, den)

%% Cargo Simulación
simu = readtable('Simulaciones\stepres.txt');
tsim = simu{:,1}; 
usim = simu{:,2};
ysim = simu{:,3};

%% Cargo Medición
Array = csvread('Mediciones\23082023\scope_27.csv', 2, 0);
tmed = Array(:, 1);
umed = Array(:, 2);
ymed = Array(:, 3);

%% Gráficos

disp('Cargando gráfico...')
hold on;
tt = 0:0.01:max(tmed);
yt = step(Gcl, tt);

plot(tt, ones(size(tt), 'like', tt), 'y')
plot(tt, yt)

%plot(simu.data, 'r')
plot(tsim, ysim, 'g')

%plot(tmed, umed, 'r')
plot(tmed, ymed, 'm')

title("Respuesta al escalón")
ylabel("Tensión (V)")
xlabel("Tiempo (s)")
xlim([0, max(tmed)])
ylim([-0.2, 1.4])
grid
legend('Entrada', 'Teoría', 'Simulación', 'Medición') 
hold off;
