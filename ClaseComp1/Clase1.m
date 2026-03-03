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

                           % Material para la Clase I

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preliminar

% Limpiamos todo:

clear
clc

% Definimos el directorio a utilizar y las carpetas que nos interesan:

cd("/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/ClaseComp1")
addpath("Figuras/")

%% Definimos parámetros y grillas

% Definimos los parámetros


beta = 0.96;
epsilon = 1e-7;

% Creamos la grilla y definimos nx:

x_grid = linspace(0.01, 10, 1000);

nx = size(x_grid,2);

% Creamos la matriz de consumo. De la restricción del problema es fácil
% notar que c_t = x_t+1 - x_t, por lo que si definimos que las filas
% correspondan a cada valor posible de x y las columnas a cada posible valor
% de x', la matriz C se puede crear de dos maneras diferentes.

% La primera, más fácil e intuitiva, pero menos eficiente en términos
% computacionales es la siguiente:

C = zeros(nx,nx);

for i = 1:nx
    for j = 1:nx
        C(i,j) = x_grid(i) - x_grid(j);
    end
end

% Debido a que trabajamos con utilidad logarítmica, la que tiene un
% comportamiento problemático alrededor del cero, puede ser conveniente
% realizar lo siguiente:

%for i = 1:nx
%    for j = 1:nx
%        C(i,j) = x_grid(i) - x_grid(j)*0.9999999;
%    end
%end

% Ello permite que para todo valor de x, exista un valor de consumo
% positivo, lo que asegurará posteriormente que la utilidad no se vaya a 
% -10^10. 

% La segunda manera equivalente de hacer ello es mediante operaciones
% matriciales. Para ello, es necesario transformar la grilla de x en un 
% vector fila y generar una matriz a partir de nx filas a partir de tal
% vector; y con la grilla de x' generar una matriz a partir de nx columnas
% a partir de tal vector fila. Ello lo hacemos con repmat. Luego, tomamos 
% la diferencia entre tales matrices. 

%C = repmat(x_grid', [1 nx])- repmat(x_grid, [nx 1]); 

C = repmat(x_grid', [1 nx])- repmat(x_grid, [nx 1])*0.9999999; 

% Para determinar la utilidad, aplicamos la función u(c) a cada valor de C.
% Ello se puede hacer de manera simple con la función log.

U = log(C);

% Asignamos un valor muy negativo a la utilidad cuando el consumo es
% negativo. 

U(C <= 0) = -1e11;


%% Value function iteration

% Definimos el número máximo de iteraciones

itermax = 1000;

% Definimos el guess inicial:

V0 = log(x_grid);

% Inicializamos tres vectores:

Vn = zeros(nx,1); % vector para guardar los máximos
index = zeros(nx,1); % inicializamos vector para guardar los índices de los
                     % x' que maximizan
V_aux = zeros(1, nx); % vector auxiliar

tic % tomamos el tiempo
for i = 1:itermax % comenzamos el proceso iterativo

    % para cada fila j y columna l, calculamos u(x-x') + beta * v_0(x')

    for j = 1:nx % indice de las filas (valor de x hoy)

        for l = 1:nx % índice para las columnas (valor de x mañana)

            V_aux(1,l) = U(j,l) + beta * V0(l); % Valor de 
                                                % u(x-x') + beta * v_0(x') 
                                                % para cada valor de x y x'
        end

        % Encontramos el máximo de V_aux dado x, y el valor de x' que 
        % maximiza V_aux. Todo ello lo hacemos para cada x, por lo que
        % vemos ello en cada fila:

        [Vn(j,1), index(j,1)] = max(V_aux, [], 2);


    end
    
    % calculamos la función de política para x:

    x_pol = x_grid(index);

    % calculamos la función de política para el consumo:

    c_pol = x_grid - x_pol;

    % distancia:
    d = max(abs(V0 - Vn));

    % condición de convergencia:
    if d < epsilon
        % si cumplimos la condición, imprimimos el número de iteraciones
        % necesarias, guardamos la solución Vn en V, y cerramos el loop.
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el 
                 % guess y comenzamos nuevamente con el procedimiento
    end 
end
toc
beep

%% Gráficos solicitados

figure(1)

plot(x_grid, V, LineStyle="-", color='red', LineWidth=2);
title('Función de valor')
xlabel('$x$', interpreter = 'latex')
ylabel('$V(x)$', interpreter = 'latex')

saveas(1, "Figuras/V_plot.pdf")



figure(2)

plot(x_grid,c_pol, LineStyle="-", color='blue', LineWidth=2); hold on
plot(x_grid,x_grid, LineStyle="--", color = 'black', LineWidth = 0.5)
title('Función de política')
xlabel('$x$', interpreter = 'latex')
ylabel('$g(x)$', interpreter = 'latex')
legend("Función de política del consumo", "Línea de 45 grados")

saveas(2, "Figuras/g_plot.pdf")

%% Value function iteration con operaciones matrices (más eficiente)

% Definimos nuevamente el número máximo de iteraciones

itermax = 1000;

% Definimos el guess inicial:

V0 = log(x_grid)';

tic
for i = 1:itermax

    % en lugar de utilizar un loop para formar V_aux en cada iteración, 
    % notamos que V(x') solo depende de x', por lo que podemos crear una 
    % matriz conformada por nx vectores fila de V0, lo que entregará V(x') 
    % para cada x y cada x', y a partir de ello computar la matriz auxiliar
    % mutiplicando ello por beta y sumando U.

    aux = U + beta * repmat(V0', [nx 1]); 

    % Encontramos el valor de x' que maximiza aux y el máximo de aux dado x:

    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra x' que
                                 % maximiza aux

    % función de política para x':

     x_pol = x_grid(index);

    % función de política para el consumo:

    c_pol = x_grid - x_pol;

    % distancia:
    d = max(abs(V0 - Vn));

    % condición de convergencia:
    if d < epsilon
        % en caso de cumplir la condición,
                               % determinamos el x' óptimo (función de
                               % política)
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep

%% ¿Convergencia monotónica?


% Definimos el guess inicial:

V0 = zeros(nx, 1);

% Inicializamos un vector para guardar las primeras diez distancias:

distancias = zeros(itermax,1); 

tic
for i = 1:itermax

    aux = U + beta * repmat(V0', [nx 1]); 

    % Encontramos el valor de x' que maximiza aux y el máximo de aux dado x:

    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra x' que
                                 % maximiza aux

    % función de política para x':

     x_pol = x_grid(index);

    % función de política para el consumo:

    c_pol = x_grid - x_pol;

    % distancia:
    d = max(abs(V0 - Vn));
    
   % para guardar las distancias de cada iteración:

    if i <= itermax
        distancias(i) = d;
    end
    
    % condición de convergencia: 
    if d < epsilon
        
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n",  i)
        V = Vn; % guardamos la solución
        break % cerramos el loop
    else
        V0 = Vn; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep

% Para ver si la convergencia es monótona, comprobamos si en cada iteración
% la distancia entre V^n y V^n+1 es menor, por lo que V^n+1 - V^n+1 debería
% ser siempre negativo.

aux0 = distancias(2:i) - distancias(1:i-1) > 0;

disp(['Iteraciones en las que crece la distancia entre el guess y la actualización: ', num2str(sum(aux0))]) 
% dado que suma cero, se comprueba que la convergencia es monótona

%% Policy function iteration

% Definimos el guess inicial para policy function como que se consume toda
% la torta para cualquier x (por lo tanto x' = g_0 (x) = 0).

c0 = x_grid;

% Definimos el guess inicial para la función valor:

V0 = zeros(nx,1);

tic
for i = 1:itermax
    aux = U + beta * repmat(V0', [nx 1]); 

    % Encontramos el valor de x' que maximiza aux y el máximo de aux dado x:

    [Vn, index] = max(aux,[],2); %Vn guarda el valor máximo, index guarda 
                                 % la posición donde se encuentra x' que
                                 % maximiza aux

    % función de política para x':

     x_pol_pfi = x_grid(index);

    % función de política para el consumo:

    c_pol_pfi = x_grid - x_pol_pfi;
    % condición de convergencia, esta vez con las policy functions:
    d = max(abs(c0 - c_pol_pfi));
    
    if d < epsilon

        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n",  i)
        V_pfi = Vn; % guardamos la solución
        break % cerramos el loop
    else
        % en caso de no cumplir la condición, actualizamos los guess
        V0 = Vn; 
        c0 = c_pol_pfi;
    end 
end
toc
beep

%% Comparación de soluciones

% definimos las funciones de política del consumo como c = x - g(x):

c_pol_analitica = x_grid*(1-beta); 

c_pol = x_grid - x_pol;

c_pol_pfi = x_grid - x_pol_pfi;

% la función valor analítica es:

V_analitica = (beta * log(beta) + (1-beta)*log(1-beta))/((1-beta)^2) + log(x_grid)/(1-beta);


% graficamos lo solicitado:

figure(3)

plot(x_grid, c_pol_analitica, LineStyle="-", LineWidth=1); hold on
plot(x_grid, c_pol, LineStyle="-", LineWidth=1); hold on
plot(x_grid, c_pol_pfi, LineStyle="-", LineWidth=1); hold on
plot(x_grid, x_grid, LineStyle="--", color = 'black', LineWidth=1); hold on
title('Función de política')
xlabel('$x$', interpreter = 'latex')
ylabel('$g(x)$', interpreter = 'latex')
legend("Función de política analítica", "Función de política VFI",...
    "Función de política PFI", Location="northwest")

saveas(3, "Figuras/comparacion_g_plot.pdf")

figure(4)

plot(x_grid,V_analitica, LineStyle="-", color='blue', LineWidth=1); hold on
plot(x_grid,V, LineStyle="-", color='red', LineWidth=1); hold on
plot(x_grid,V_pfi, LineStyle="-", color='green', LineWidth=1); hold on
title('Función de política')
xlabel('$x$', interpreter = 'latex')
ylabel('$v(x)$', interpreter = 'latex')
legend("Función de valor analítica", "Función de valor VFI",...
    "Función de valor PFI", Location="best")

saveas(4, "Figuras/comparacion_V_plot.pdf")