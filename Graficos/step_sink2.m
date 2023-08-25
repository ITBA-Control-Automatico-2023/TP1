%% Control Autom�tico TP1 - Gr�fico respuesta escal�n sin k2

clear all;
clc;

cd 'C:\Users\User\Repos\TP1\'

%% Cargo funci�n transferencia
disp('*******************************')

xi = 0;
wn = sqrt(10^4/47);
num = [wn^2];
den = [1, 2*xi*wn, wn^2];
Gcl = tf(num, den)

%% Cargo Simulaci�n
simu = readtable('Simulaciones\stepres_sink2.txt');
tsim = simu{:,1}; 
usim = simu{:,2};
ysim = simu{:,3};

%% Cargo Medici�n
Array = csvread('Mediciones\23082023\scope_30.csv', 2, 0);
tmed = Array(:, 1);
umed = Array(:, 2);
ymed = Array(:, 3);

%% Gr�ficos

disp('Cargando gr�fico...')
hold on;
tt = 0:0.01:max(tmed);
yt = step(Gcl, tt);

plot(tt, ones(size(tt), 'like', tt), 'y')
plot(tt, yt)

%plot(simu.data, 'r')
plot(tsim, ysim, 'g');

%plot(tmed, umed, 'r')
plot(tmed, ymed, 'm')

title("Respuesta al escal�n")
ylabel("Tensi�n (V)")
xlabel("Tiempo (s)")
xlim([0, max(tmed)])
ylim([-0.5, 2.5])
grid
legend('Entrada', 'Teor�a', 'Simulaci�n', 'Medici�n') 
hold off;
