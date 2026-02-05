% Cápsula de Gráficos - Programación Dinámica.
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

% Leemos los datos de la base de datos indicada:
gini = readtable('Datos/gini.xlsx');

% Filtramos los datos correspondientes a Estados Unidos

gini_us = gini(ismember(gini.Country,{'United States'}), :);

% Creamos la figura:

figure(1)

% Creamos el gráfico dentro de la figura:

plot(gini_us.Year, gini_us.GiniCoefficient_beforeTax__WorldInequalityDatabase_, ...
    '-', Color='red', LineWidth=1.5);
xlabel('Año'); 
ylabel('Índice de Gini');
title('Índice de Gini en Estados Unidos entre 1914 y 2022')
xlim([1912,2024]);
saveas(1,'Figuras/Figura_P1.jpeg')

%% Pregunta 2

% Filtramos los datos correspondientes a los países indicados. 

gini_cl = gini(ismember(gini.Country,{'Chile'}), :);
gini_chn = gini(ismember(gini.Country,{'China'}), :);
gini_fr = gini(ismember(gini.Country,{'France'}), :);

% Notamos que tenemos datos para los cuatro países solo entre 2001 y 2016.
% Por lo tanto, redefinimos como

gini_cl = gini_cl(gini_cl.Year >= 2001 & gini_cl.Year <= 2016,:);
gini_chn = gini_chn(gini_chn.Year >= 2001 & gini_chn.Year <= 2016,:);
gini_fr = gini_fr(gini_fr.Year >= 2001 & gini_fr.Year <= 2016,:);
gini_us = gini_us(gini_us.Year >= 2001 & gini_us.Year <= 2016,:);

% Creamos la figura y el gráfico:

figure(2)
plot(gini_cl.Year, gini_cl.GiniCoefficient_beforeTax__WorldInequalityDatabase_, ...
    '-', LineWidth=1.5); hold on
plot(gini_chn.Year, gini_chn.GiniCoefficient_beforeTax__WorldInequalityDatabase_, ...
    '-', LineWidth=1.5); hold on
plot(gini_fr.Year, gini_fr.GiniCoefficient_beforeTax__WorldInequalityDatabase_, ...
    '-', LineWidth=1.5); hold on
plot(gini_us.Year, gini_us.GiniCoefficient_beforeTax__WorldInequalityDatabase_, ...
    '-', LineWidth=1.5);
xlabel('Año');
ylabel('Índice de Gini');
title('Índice de Gini en cuatro países entre 2001 y 2016')
xlim([2001,2016]);
legend('Chile', 'China', 'Francia', 'Estados Unidos', Location='northwest')

saveas(2,'Figuras/Figura_P2.jpeg')

%% Pregunta 3

clearvars

gdp_pc = readtable('Datos/pib_pc.xlsx');


figure(3)

set(gca,'XScale','log')



histogram(gdp_pc.GDP, 30, FaceColor='green', FaceAlpha=0.3); hold on
title('Distribución del PIB per cápita de 2022 en escala logarítmica');
xlabel('Logaritmo del PIB per cápita', Interpreter='latex');
ylabel('Frecuencia')

saveas(3,'Figuras/Figura_P3.jpeg')



%% Pregunta 4

clear

% Con linspace creamos una grilla de valores para beta y sigma. Con
% meshgrid podemos generar una matriz de puntos, la que será útil para
% generar el gráfico en tres dimensiones

[beta,sigma] = meshgrid(linspace(0.01,1,100), linspace(1.1,5, 100));

% Definimos la tasa de interés

r = 0.03;

% Computamos el consumo óptimo:

c_1 = 100./(1 + (beta * (1+r)).^(-sigma)/(1+r));

% Generamos la figura

figure(4)

surf(beta, sigma, c_1);
colorbar
xlabel('$\beta$', Interpreter='latex');
ylabel('$\sigma$', Interpreter='latex');
zlabel('$c_1$', Interpreter='latex');
title('Consumo óptimo en periodo 1');
subtitle('para diferentes valores de la EIS y del descuento intertemporal')


saveas(4, 'Figuras/Figura_P4.jpeg')