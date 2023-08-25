%% Control Autom�tico TP1 - Gr�fico respuesta cuadarada

clear all;
clc;

cd 'C:\Users\User\Repos\TP1\'

%% Cargo funci�n transferencia
disp('*******************************')

xi = -log(20/100)/sqrt(pi^2 + log(20/100)^2);
wn = sqrt(10^4/47);
num = [wn^2];
den = [1, 2*xi*wn, wn^2];
Gcl = tf(num, den)

%% Cargo Simulaci�n
simu = readtable('Simulaciones\sqres.txt');
tsim = simu{:,1}; 
usim = simu{:,2};
ysim = simu{:,3};

%% Cargo Medici�n
Array = csvread('Mediciones\23082023\scope_15.csv', 2, 0);
tmed = Array(:, 1);
umed = Array(:, 2);
ymed = Array(:, 3);

%% Gr�ficos

disp('Cargando gr�fico...')
hold on;
tt = -2:0.01:10;
sq = 2*square(2*1.57*tt);
yt = lsim(Gcl, sq, tt);

plot(tt, sq, 'y');
plot(tt, yt);

%plot(simu.data, 'r')
plot(tsim, ysim, 'g');

%plot(tmed, umed, 'r')
plot(tmed+1, ymed, 'm')

xlim([0, max(tmed) + 1])
title("Respuesta a cuadrada de 4Vpp y 0.5Hz")
ylabel("Tensi�n (V)")
xlabel("Tiempo (s)")
grid
legend('Entrada', 'Teor�a', 'Simulaci�n', 'Medici�n') 
hold off;
