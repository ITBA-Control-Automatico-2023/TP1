%% Control Automático TP1 - Gráfico plano de fase sin k2

clear all;
clc;

cd 'C:\Users\User\Repos\TP1\'

%% Cargo curva teórica
x1teo = load('Graficos\stepX1_sink2.mat');
x2teo = load('Graficos\stepX2_sink2.mat');

%% Cargo Simulación
simu = readtable('Simulaciones\stepXY_sink2.txt');
tsim = simu{:,1}; 
x2sim = simu{:,2};
x1sim = simu{:,3};

%% Cargo Medición
Array = csvread('Mediciones\25082023\scope_38.csv', 2, 0);
tmed = Array(:, 1);
x2med = Array(:, 2);
x1med = Array(:, 3);

%% Gráficos

disp('Cargando gráfico...')
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
legend('Teoría', 'Simulación', 'Medición') 
hold off;
