% Minicurso - Programación Dinámica
% Otoño 2026.
% Profesor: Eduardo Engel.
% Ayudante: Agustín Farías Lobo.

% Primera versión: febrero de 2025.
% Esta versión: febrero de 2026.

% Original computational setup.
% OS: macOS Tahoe 26.3.
% Software: Matlab R2025b.
% CPU: Apple M5.
% RAM: 16 GB.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                           % Solución P2 - TDA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Preliminar

% En esta parte del código definimos el directorio en el que trabajaremos.
% Ello permitirá mantener un código ordenado.

% Primero limpiamos el enviroment ('clear') y la consola ('clc'):

clear
clc

% Para definir el directorio, utilizamos la función 'cd'

cd('/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/TDA/P2')
addpath('Funciones/')

%% Pregunta 2

% En primer lugar, la función para calcular derivadas numéricas se define
% en la carpeta de funciones y se nombra der.m.

% La función para generar x_n+1 se encuentra en la carpeta de funciones. Se
% nombra step_n.m.

% La función que genera el algoritmo Newton-Raphson se encuentra en la
% carpeta de funciones. Se nombra NR.m.

% Se encuentran las raíces de las funciones dadas en el enunciado:

f = @(x) x.^2;

g = @(x) x.^3 - (x-2).^5;

h = @(x) exp(-x) + log(x)./log(0.2);

[root_f, iter_f] = NR(f,-10);

[root_g, iter_g] = NR(g,4);

[root_h, iter_h] = NR(h,10);

