%% Control Autom�tico TP1 - Gr�fico plano de fase sin k2

clear all;
clc;

cd 'C:\Users\User\Repos\TP1\'

%% Cargo curva te�rica
x1teo = load('Graficos\stepX1_sink2.mat');
x2teo = load('Graficos\stepX2_sink2.mat');

%% Cargo Simulaci�n
simu = readtable('Simulaciones\stepXY_sink2.txt');
tsim = simu{:,1}; 
x2sim = simu{:,2};
x1sim = simu{:,3};

%% Cargo Medici�n
Array = csvread('Mediciones\25082023\scope_38.csv', 2, 0);
tmed = Array(:, 1);
x2med = Array(:, 2);
x1med = Array(:, 3);

%% Gr�ficos

disp('Cargando gr�fico...')
hold on;

plot(x2teo.data.Data, x1teo.data.Data);

plot(x2sim, x1sim, 'g')

plot(x2med, x1med, 'm')

title("Plano de fase")
xlabel("X2 (V)")
ylabel("X1 (V)")
xlim([-1, 1])
ylim([-0.5, 2.5])
grid
legend('Teor�a', 'Simulaci�n', 'Medici�n') 
hold off;
