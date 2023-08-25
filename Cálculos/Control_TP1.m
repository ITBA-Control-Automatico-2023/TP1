%% Control Automático TP1

clear all;
clc;

%% Datos del circuito
disp('******************************************')
R = [10E3, 10E3, 10E3, 10E3, 100E3, 10E3, 10E3, 47E3, 10E3, 10E3];
C5 = 1E-6;
C6 = 1E-6;

%% Calculo impedancias
s = sym('s');
ZR = R;
ZC5 = 1/(s*C5);
ZC6 = 1/(s*C6);

%% Obtengo transferencias
OA1 = -ZR(2)/ZR(1);
OA2 = -ZR(4)/ZR(3);
OA3 = -ZC5/ZR(5);
OA4 = -ZR(7)/ZR(6);
OA5 = -ZC6/ZR(8);
OA6 = -ZR(10)/ZR(9);

% Con los Opamps conectados en cascada, obtengo transferencia total
disp('Transferencia del circuito')
G = OA1*OA2*OA3*OA4*OA5*OA6

%% Forma canónica de variables de fase
disp('******************************************')
disp('Forma canónica de variables de fase')
A = [0, 1000/47; 0, 0];
B = [0; 10];
C = [1, 0];
D = 0;
Sf = ss(A, B, C, D)

%% Chequeo transferencia
disp('Chequeo transferencia')
[num, den] = ss2tf(A, B, C, D);
G = tf(num, den);
zpk(G)

%% Chequeo controlabilidad
MC = [B, A*B];
if det(MC) ~= 0
    disp('Es controlable')
else
    disp('No es controlable')
end

%% Realimentación de estados
disp('******************************************')
OS = 20;        % Buscamos sobrepico <= 20%
xi = -log(OS/100)/sqrt(pi^2 + log(OS/100)^2);

%% Calculo transferencia a lazo cerrado
k1 = sym('k1');
k2 = sym('k2');

K = [k1, k2];

% Matriz A de lazo cerrado
Acl = A - B*K;

disp('Transferencia a lazo cerrado')
Gcl = C*inv(s*eye(size(Acl, 1)) - Acl)*B+D;

[num, den] = numden(Gcl);
den = flip(coeffs(den, 's'));
num = flip(coeffs(num, 's'))/den(1);
den = den/den(1);
vpa(poly2sym(num, s)/poly2sym(den, s), 5)

%% Resuelvo Ks
% Condición 1: TI del denominador igual a la ganancia del sistema
k1 = double(solve(num == den(size(den, 2)), k1))

% Condición 2: OS% <= 20%
k2 = double(solve(2*xi*double(sqrt(num)) == den(size(den, 2) - 1), k2))

%% Calculo transferencia a lazo cerrado resultante
disp('Transferencia a lazo cerrado resultante')
K = [k1, k2];
Acl = A - B*K;
[num, den] = ss2tf(Acl, B, C, D);
Gcl = tf(num, den)

%% Grafico escalón
disp('*******************************')
% Grafico
disp('Cargando gráfico...')
hold on;
t = 0:0.01:5;
step(Gcl, t)
ylabel('Respuesta del modelo al escalón')
grid
hold off;

%% Calculo error permanente
ess = 1+C*(inv(Acl))*B
