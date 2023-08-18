%% Control Automático TP1

clear all;
clc;

%% Forma canónica de variables de fase
disp('************************')
disp('Forma canónica de variables de fase')
A = [0, 1000/47; 0, 0];
B = [0; 10];
C = [1, 0];
D = 0;
Sf = ss(A, B, C, D)

%% Saco transferencia
disp('Calculo transferencia')
s = sym('s');
G = C * (s*eye(size(A, 1)) - A)^(-1)*B + D
% Normalizo
[num, den] = numden(G);
den = sym2poly(den);
num = sym2poly(num)/den(1);
den = den/den(1);
G = tf(num, den);
zpk(G)

disp('Chequeo transferencia')
[num2, den2] = ss2tf(A, B, C, D);
G2 = tf(num2, den2);
zpk(G2)

disp('transferencia OK')

%% Residuos para fracciones simples
disp('************************')

[n, d, ] = residue(num, den)

%% Chequeo controlabilidad
MC = [B, A*B];
if det(MC) ~= 0
    disp('Es controlable')
else
    disp('No es controlable')
end

%% Chequeo observabilidad
MO = [C; C*A]
if det(MO) ~= 0
    disp('Es observable')
else
    disp('No es observable')
end

%% Chequeo polos
p = eig(A);
p1 = p(1)
p2 = p(2)

%% Realimentación de estados
OS = 20;
xi = -log(OS/100)/sqrt(pi^2 + log(OS/100)^2)
wn = sym('wn')

% Calculo transferencia deseada
disp('Transferencia deseada')
numd = wn^2
dend = [1, 2*xi*wn, wn^2]

%% Cálculos para encontrar K
disp('Nuevo polinomio característico')
s = sym('s');
vpa(collect((s-p1)*(s-p2)), 5)

k1 = sym('k1');
k2 = sym('k2');

K = [k1, k2];

Acl = A - B*K

disp('Determinante de A de lazo cerrado')
vpa(collect(det(s*eye(size(Acl, 1)) - Acl)), 5)

%% Calculo transferencia a lazo cerrado
disp('Transferencia a lazo cerrado')
Acl = A - B*K
s = sym('s');
Gcl = C*inv(s*eye(size(Acl, 1)) - Acl)*B+D

[num, den] = numden(Gcl);
den = flip(coeffs(den, 's'));
num = flip(coeffs(num, 's'))/den(1);
den = den/den(1);

%% Resuelvo Ks

% Condición 1: TI del denominador igual a la ganancia del sistema
k1 = double(solve(num == den(size(den, 2)), k1))

% Condición 2: OS% <= 20%
k2 = double(solve(2*xi*double(sqrt(num)) == den(size(den, 2) - 1), k2))

%% Chequeo transferencia
K = [k1, k2];
Acl = A - B*K;
[num, den] = ss2tf(Acl, B, C, D);
Gcl = tf(num, den)
zpk(minreal(Gcl))

%% Chequeo realimentación
disp('Constantes de realimentación')
p = pole(Gcl)
K = acker(A, B, p)

%% Grafico escalón
disp('*******************************')
% Grafico
disp('Cargando gráfico...')
hold on;
t = 0:0.05:5;
step(Gcl, t)
ylabel('Respuesta del modelo al escalón')
grid
hold off;
