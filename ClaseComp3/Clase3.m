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

                           % Material para la Clase III

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Preliminar

% Limpiamos todo:

clear
clc

% Definimos el directorio a utilizar y las carpetas que nos interesan:

cd("/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/ClaseComp3")
addpath("Figuras/")
addpath("Funciones/")

%% Definimos parámetros y grillas

% Definimos los parámetros

alpha = 0.33;
beta = 0.95;
delta = 0.1;
sigma = 2;

epsilon = 1e-7;

% El capital de estado estacionario está dado por 

k_ss = (1/alpha * (1/beta - 1 + delta))^(1/(alpha-1));

% Se crea la grilla del capital:

k_grid = linspace(0.1, 2*k_ss, 1000);

nk = size(k_grid, 2);

% Creamos la matriz para el consumo a partir de la restricción
% presupuestaria, la que establece que c = f(k) + (1-delta)k - k'

C = repmat(k_grid', [1,nk]).^alpha + (1-delta).* repmat(k_grid', [1,nk])...
    - repmat(k_grid, [nk,1]);

% Creamos la función U.m (presente en la carpeta de funciones). Obtenemos
% el valor de la utilidad para cada C:

U_c = U(C,sigma);


%% Value function iteration


% Definimos el número máximo de iteraciones

itermax = 1000;

% Definimos el guess inicial:

V0 = zeros(nk,1);

tic
for i = 1:itermax

    % Creamos la matriz auxiliar y luego respecto a k' (buscamos el máximo
    % de cada fila, por lo que operamos en las columnas):

    aux = U_c + beta * repmat(V0', [nk 1]); 

    % Encontramos el valor de k' que maximiza aux y el máximo de aux dado k:
    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra k' que
                                 % maximiza aux

    % función de política de k':

    k_pol = k_grid(index);

    % distancia:
    d = max(abs(V0 - Vn));

    % condición de convergencia:

    if d < epsilon

        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep




%% Gráficos solicitados

figure(1)

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(2,1,1)

plot(k_grid, V, LineStyle="-", color='red', LineWidth=2);
title('Función de valor')
xlabel('$k$', interpreter = 'latex')
ylabel('$V(k)$', interpreter = 'latex')


subplot(2,1,2)

plot(k_grid,k_pol, LineStyle="-", color='blue', LineWidth=2); hold on
plot(k_grid,k_grid, LineStyle="--", color = 'black', LineWidth = 0.5); hold on
xline(k_ss, LineStyle='--', LineWidth=0.5, Color='red');

title('Función de política')
xlabel('$k$', interpreter = 'latex')
ylabel('$g(k)$', interpreter = 'latex')
legend("Función de política", "Línea de 45 grados", "Steady state", Location="northwest")

saveas(1, "Figuras/Policy_Value.pdf")

%% Funciones de política para i y c:

i_pol = k_pol - (1-delta)*k_grid;

c_pol = k_grid.^alpha - i_pol;

%% Gráficos:

figure(2)
plot(k_grid,k_pol, LineStyle="-", color='blue', LineWidth=2); hold on
plot(k_grid,i_pol, LineStyle="-", color='red', LineWidth=2); hold on
plot(k_grid,c_pol, LineStyle="-", color='magenta', LineWidth=2); hold on
xline(k_ss, '--', LineWidth=2, Color='black');
plot(k_grid, k_grid, '-.', LineWidth=0.5, Color='black');
title('Funciones de política')
xlabel('$k$', interpreter = 'latex')
ylabel('$g(k), i(k), c(k)$', interpreter = 'latex')
legend("g(k)", "i(k)", 'c(k)', "Steady state", Location="northwest")


%% Función de valor para diferentes betas


itermax = 10000;

% Definimos el guess inicial esta vez dentro del loop de betas:

% Definimos el vector de betas sobre el que iteraremos

aux_beta = [0.99, 0.95, 0.9, 0.8, 0.5];

nb = size(aux_beta,2);



% Inicializamos dos matrices de nk nk 5 para guardar la value function y
% policy funcion para cada beta

V = zeros(nk,nb);
k_pol = zeros(nk,nb);



for j = 1:nb
    tic
    beta = aux_beta(j);
    V0 = zeros(nk, 1);
    for i = 1:itermax

        % Creamos la matriz auxiliar y luego respecto a k' (buscamos el máximo
        % de cada fila, por lo que operamos en las columnas):

        aux = U_c + beta * repmat(V0', [nk 1]); 

        % Encontramos el valor de k' que maximiza aux y el máximo de aux dado k:
        [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra k' que
                                 % maximiza aux

        % función de política de k':

        k_pol(:,j) = k_grid(index);

        % distancia:
        d = max(abs(V0 - Vn));
        
        % condición de convergencia:

        if d < epsilon
            fprintf("\n Para el caso cuando beta es %g tenemos que el procedimiento iterativo de la función valor \n converge en la iteración número %g \n", beta, i)
            V(:,j) = Vn; % guardamos la solución
            break % cerramos el loop
        else
            V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
        end 
    end
    toc
    beep
end
%toc

%% Graficamos
 
% Graficamos todas las value functions y las policy functions en una sola
% figura:

figure(3)

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

for j = 1:nb

    subplot(nb,2,2*j-1)

    plot(k_grid, V(:,j), LineStyle="-", color='red', LineWidth=2);
    title('Función de valor')
    xlabel('$k$', interpreter = 'latex')
    ylabel('$V(k)$', interpreter = 'latex')


    subplot(nb,2,2*j)

    plot(k_grid,k_pol(:,j), LineStyle="-", color='blue', LineWidth=2); hold on
    plot(k_grid,k_grid, LineStyle="--", color = 'black', LineWidth = 0.5); hold on
    title('Función de política')
    xlabel('$k$', interpreter = 'latex')
    ylabel('$g(k)$', interpreter = 'latex')
    legend("Función de política", "Línea de 45 grados", Location="northwest")

end

saveas(3, "Figuras/Policy_Value_betas.pdf")


%% Comparando con la solución analítica de clases

% Definimos los parámetros

alpha = 0.33;
beta = 0.95;
delta = 1;
sigma = 1;

epsilon = 1e-7;

% El capital de estado estacionario está dado por 

k_ss = (1/alpha * (1/beta - 1 + delta))^(1/(alpha-1));

% Se crea la grilla del capital:

k_grid = linspace(0.1, 2*k_ss, 1000);

nk = size(k_grid, 2);

% Creamos la matriz para el consumo a partir de la restricción
% presupuestaria, la que establece que c = f(k) + (1-delta)k - k'

C = repmat(k_grid', [1,nk]).^alpha + (1-delta).* repmat(k_grid', [1,nk])...
    - repmat(k_grid, [nk,1]);

% Creamos la función U.m (presente en la carpeta de funciones). Obtenemos
% el valor de la utilidad para cada C:

U_c = U(C,sigma);

% Value function iteration

% Definimos el número máximo de iteraciones

itermax = 10000;

% Definimos el guess inicial:

V0 = zeros(nk,1);

tic
for i = 1:itermax

    % Creamos la matriz auxiliar y luego respecto a k' (buscamos el máximo
    % de cada fila, por lo que operamos en las columnas):

    aux = U_c + beta * repmat(V0', [nk 1]); 

    % Encontramos el valor de k' que maximiza aux y el máximo de aux dado k:
    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra k' que
                                 % maximiza aux

    % función de política de k':

    k_pol = k_grid(index);

    % distancia:
    d = max(abs(V0 - Vn));

    % condición de convergencia:

    if d < epsilon

        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep

% La solución analítica está dada por 

V_analitica = 1/((1-alpha*beta)*(1-beta))* ((1-alpha*beta) * log(1-alpha*beta)...
                + alpha * beta * log(alpha*beta)) + alpha/(1-alpha*beta) .* log(k_grid);

k_pol_analitica = alpha*beta*k_grid.^(alpha);

%% Comparamos con un gráfico

figure(4)

plot(k_grid, V, LineStyle='-', LineWidth=2,Color='red'); hold on
plot(k_grid, V_analitica, LineStyle='--', lineWidth=2, Color='blue'); hold on
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
title('Función valor: solución numérica y analítica')
xlabel('$k$', interpreter = 'latex')
ylabel('$V(k)$', interpreter = 'latex')
legend("Solución numérica", "Solución analítica", Location="northwest")

saveas(4, "Figuras/V_soluciones.pdf")


figure(5)

plot(k_grid, k_pol, LineStyle='-', LineWidth=2,Color='red'); hold on
plot(k_grid, k_pol, LineStyle='--', lineWidth=2, Color='blue'); hold on
plot(k_grid, k_grid, LineStyle='--', LineWidth=1, color='black')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
title('Función de política: solución numérica y analítica')
xlabel('$k$', interpreter = 'latex')
ylabel('$g(k)$', interpreter = 'latex')
legend("Solución numérica", "Solución analítica", "Línea de 45 grados", Location="northwest")

saveas(5, "Figuras/g_soluciones.pdf")


%% Caso con sigma = 0.99999:

sigma = 0.99999;

% Obtenemos el valor de la utilidad para cada C:

U_c = U(C,sigma);

% Value function iteration

% Definimos el número máximo de iteraciones

itermax = 10000;

% Definimos el guess inicial:

V0 = zeros(nk,1);

tic
for i = 1:itermax

    % Creamos la matriz auxiliar y luego respecto a k' (buscamos el máximo
    % de cada fila, por lo que operamos en las columnas):

    aux = U_c + beta * repmat(V0', [nk 1]); 

    % Encontramos el valor de k' que maximiza aux y el máximo de aux dado k:
    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra k' que
                                 % maximiza aux

    % función de política de k':

    k_pol = k_grid(index);

    % distancia:
    d = max(abs(V0 - Vn));

    % condición de convergencia:

    if d < epsilon

        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V_2 = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep

%% Caso con sigma = 1.00001:

sigma = 1.000001;

% Obtenemos el valor de la utilidad para cada C:

U_c = U(C,sigma);

% Value function iteration

% Definimos el número máximo de iteraciones

itermax = 10000;

% Definimos el guess inicial:

V0 = zeros(nk,1);

tic
for i = 1:itermax

    % Creamos la matriz auxiliar y luego respecto a k' (buscamos el máximo
    % de cada fila, por lo que operamos en las columnas):

    aux = U_c + beta * repmat(V0', [nk 1]); 

    % Encontramos el valor de k' que maximiza aux y el máximo de aux dado k:
    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra k' que
                                 % maximiza aux

    % función de política de k':

    k_pol = k_grid(index);

    % distancia:
    d = max(abs(V0 - Vn));

    % condición de convergencia:

    if d < epsilon

        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V_3 = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep

%% Comparamos con un gráfico:

figure(6)
plot(k_grid, V, LineStyle='-', LineWidth=5); hold on
plot(k_grid, V_2, LineStyle='-', LineWidth=2); hold on
plot(k_grid, V_3, LineStyle='-', LineWidth=1); hold on
title('Función valor')
xlabel('$k$', interpreter = 'latex')
ylabel('$V(k)$', interpreter = 'latex')
legend("$\sigma=1$", "$\sigma = 0.99999$", "$\sigma = 1.00001$",...
    Location="northwest", Interpreter = 'latex')

saveas(6,'Figuras/Comparacion_V_log.pdf')


%% Caso estocástico. z_t sigue una cadena de Markov de primer orden

clearvars

% Definimos parámetros:

alpha = 0.33;
beta = 0.95;
delta = 0.1;
sigma = 2;

epsilon = 1e-7;

% El capital de estado estacionario está dado por 

k_ss = (1/alpha * (1/beta - 1 + delta))^(1/(alpha-1));

% Se crea la grilla del capital:

k_grid = linspace(0.1, 2*k_ss, 1000);

nk = size(k_grid,2);

% Matriz de transición:

P = [0.85, 0.15; 0.15, 0.85];

z_grid = [0.9, 1.1];

nz = size(z_grid,2);

% Creamos un arreglo tridimensional para el consumo a partir de la 
% restricción presupuestaria, la que establece que 
% c = zk^alpha + (1-delta)k - k'

C = zeros(nk, nk, nz);


for j = 1:nz
    C(:,:,j) = z_grid(j) * repmat(k_grid', [1,nk]).^alpha + ...
        (1-delta).* repmat(k_grid', [1,nk]) - repmat(k_grid, [nk,1]);
end


U_c = U(C,sigma);

% Guess inicial:

V0 = zeros(nk,nz);

% Inicializamos matrices para guardar las actualizaciones de la value
% function y la policy function:

Vn = zeros(nk,nz);
k_pol = zeros(nk,nz);



% Iniciamos iteraciones y tomamos el tiempo:
itermax = 10000;

tic
for i = 1:itermax

    % A partir del guess inicial para v(k,z), obtenemos E[v(k',z')] para cada
    % k y z. En este caso, E[v(k',z') | z = 0.9) =/= E[v(k',z') | z = 1.1),
    % por lo que debemos obtener la esperanza condicional de V(k',z')
    % para cada z. Para ello utilizamos un loop e iteramos sobre los 
    % posibles valores de z:

    for z = 1:nz
        
        % Esperanza condicional de V(k',z'):

        V0_exp = sum(V0 .* P(z,:),2);

        % Encontramos el valor de k' que maximiza la matriz auxiliar dado k
        % y z,y el máximo de ella dado k y z:

        [Vn(:,z), index] = max(U_c(:,:,z) + beta * repmat(V0_exp', [nk 1]),[],2);
        
        k_pol(:,z) = k_grid(index);

    end
    % distancia (esta vez encontramos el maximo dado k y dado z, por ello 
    % ocupamos doble la función max):

    d = max(max(abs(V0 - Vn)));
    
    % condición de convergencia:

    if d < epsilon
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep

%% Graficamos:

figure(7)
plot(k_grid, V(:,1), LineStyle="-", color='red', LineWidth=2); hold on
plot(k_grid, V(:,2), LineStyle="-", color='blue', LineWidth=2);
title('Función de valor');
xlabel('$k$', interpreter = 'latex');
ylabel('$V(k,z)$', interpreter = 'latex');
legend('z = 0.9', 'z = 1.1', Location='best');


figure(8)
plot(k_grid, k_pol(:,1), LineStyle="-", color='red', LineWidth=2); hold on
plot(k_grid, k_pol(:,2), LineStyle="-", color='blue', LineWidth=2); hold on
plot(k_grid, k_grid, LineStyle="--", color='black', LineWidth=0.5);
title('Función de política');
xlabel('$k$', interpreter = 'latex');
ylabel('$g(k,z)$', interpreter = 'latex');
legend('z = 0.9', 'z = 1.1', Location='best');

saveas(7, "Figuras/V_Markov.pdf")
saveas(8, "Figuras/Policy_Markov.pdf")


