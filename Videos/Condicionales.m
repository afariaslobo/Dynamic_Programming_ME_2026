% Cápsula de funciones condicionales - Programación Dinámica.
% Otoño 2025.
% Profesor: Eduardo Engel.
% Ayudante: Agustín Farías Lobo.


%%

clear 
clc

cd('/Users/afl/Library/CloudStorage/GoogleDrive-afariaslobo@gmail.com/My Drive/Universidad/Sexto año/Dynamic Programming/Videos')

addpath("Datos/")
addpath("Figuras/")

%% Pregunta 1

% Definimos los vectores solicitados:

v = 1:5;
m = [-2, 3; 5, -2];

% Encontramos los índices los elementos mayores o iguales a 3 de v, y a
% partir de ello imprimimos los elementos que son mayores o iguales a 3 de
% v:

v(v >= 3)

% Encontramos los índices los elementos estrictamente positivos de m, y a
% partir de ello imprimimos los elementos estrictamente positivos de m:

m(m > 0)

%% Pregunta 2

% Definimos la matriz m2:

m2 = [2, 3, 10; -4, 1, -7; 9, -1, 12];


% Reemplazamos los valores negativos redefiniendo tales valores:

m3 = m2;

m3(m2 < 0) = 0;

%% Pregunta 3

% Definimos el vector solicitado:

vec = [0, -5, -3];

% Definimos las condiciones y los output descritos en el enunciado:

if vec(1) > 0 && vec(2) > 0 && vec(3) > 0
    disp('Todos los números son positivos.')
elseif and(vec(1) <= 0 || vec(2) <= 0 || vec(3) <= 0, vec(1) > 0 || vec(2) > 0 || vec(3) > 0)
    disp('No todos los números son positivos.')
else
    disp('Todos los números son no positivos.')
end


%% Pregunta 4

% Definimos el vector:

vec2 = [2.4, 4, 1];

% Definimos las condiciones y los output descritos en el enunciado. Para
% ver si es que un número es entero utilizamos la función floor, la que
% trunca un número a su entero más cercano. Luego, si floor(x) no es igual
% a x, x no es un entero.

if and(vec2(1) > 0, floor(vec2(1)) == vec2(1)) && ...
        and(vec2(2) > 0, floor(vec2(2)) == vec2(2)) ...
        && and(vec2(3) > 0, floor(vec2(3)) == vec2(3))
    disp('Todos los números cumplen con las condiciones')
else
    disp('No todos los números son enteros positivos')
end

%% Pregunta 5

% Definimos las notas del curso:

mate = [1, 3, 4];

quizzes = [2, 6, 5.5, 7];

comp = 2;

% Definimos las notas de cada parte

nota1 = sum(mate)/3;

nota2 = sum(quizzes)/4 * 0.5 + comp * 0.5;

% Imponemos las condiciones e imprimimos el texto solicitado:

if nota1 >= 3.95 && nota2 >= 3.95
    disp('Aprueba el curso')
elseif nota1 < 3.95 && nota2 >= 3.95
    disp('Reprueba por su nota en la parte de Jorge Rivera')
elseif nota1 >= 3.95 && nota2 < 3.95
    disp('Reprueba por su nota en la parte de Eduardo Engel')
else
    disp('Reprueba por su nota en ambas partes')
end