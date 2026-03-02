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

                           % Solución P1 - TDA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Preliminar

% En esta parte del código definimos el directorio en el que trabajaremos.
% Ello permitirá mantener un código ordenado.

% Primero limpiamos el enviroment ('clear') y la consola ('clc'):

clear
clc

% Para definir el directorio, utilizamos la función 'cd'

cd('/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/TDA/P1')

% Para poder utilizar directamente carpetas dentro del directorio,
% utilizamos la función 'addpath'

addpath('Datos/')
addpath('Figuras/')

%% Pregunta 1

% En primer lugar leemos la base de datos con la función readmatrix o
% readtable. Puede ocuparse cualquiera de ellas, pero trabajar con matrices
% puede ser más fácil para ciertas operaciones.

base = readtable("Datos/base_p1.xlsx");
mat = readmatrix("Datos/base_p1.xlsx");

% Primero obtenemos la serie de la inflación con la diferencia del
% logaritmo de IPC con el logaritmo del doceavo rezago del IPC:

pi = log(mat(13:end,3)) - log(mat(1:end-12,3));

% Definimos la matriz X con las columnas 2 y 4 de la base de datos
% (recordar que perdemos los primeros doce datos para obtener la inflación):

X = mat(13:end,[2,4]);

% Definimos la matriz Y con la inflación:

Y = pi*100;

% Para utilizar la función regress y estimar con intercepto, es necesario
% incluir una columna de unos a la matriz X.

N = size(X,1); % Número de filas de X

X_c = [ones(N,1), X]; % Incluimos la columna de unos con la función ones

% Estimamos utilizando regress:

beta_hat2 = regress(Y,X_c);

% Se crea la función de OLS. Ella está presente en la carpeta "Funciones".

% Estimamos el modelo con la función OLS.

beta_hat = OLS(X,Y);

% Para ver si los resultados son equivalentes, utilizamos una condición
% logica y sumamos los resultados de la condición.

error = sum(beta_hat2 == beta_hat); 

% Como el error es cero, concluimos que son equivalentes.

% Para obtener las predicciones, basta con multiplicar la matriz X
% (incluyendo la columna de unos) por el vector de coeficientes estimados.

Y_hat = [ones(size(X,1),1), X] * beta_hat;

% Para hacer el gráfico con un formato de fecha, aprovechamos la base en
% formato table. 

tab_plot = table(base.Periodo(13:end), pi*100, Y_hat, ...
                 VariableNames={'Periodo', 'Inflacion', 'Prediccion'});



% A continuación creamos los gráficos:

figure(1)

plot(tab_plot.Periodo, tab_plot.Inflacion, '-', LineWidth=1.5, Color='red'); hold on
% utilizar 'hold on' nos permite sobreponer gráficos
plot(tab_plot.Periodo, tab_plot.Prediccion, '--', LineWidth=1.5, Color='blue');
xlabel('Periodo'); % Ajustamos el nombre del eje x
ylabel('Inflación (%)'); % Ajustamos el nombre del eje y
legend('Inflación observada', 'Inflación predicha', Location='northwest');
% Creamos una leyenda
title('Inflación en doce meses en Chile'); % Incluimos título
subtitle('entre enero de 2014 y noviembre de 2024'); % Incluimos subtítulo

% Guardamos la figura en formato vectorizado (.eps) y en formato
% tradicional (.jpeg).

saveas(1,'Figuras/Figura_P1.eps')
saveas(1,'Figuras/Figura_P1.jpeg')