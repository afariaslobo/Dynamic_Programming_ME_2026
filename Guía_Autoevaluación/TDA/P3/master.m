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

cd('/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/TDA/P3')

%% Parametrización


alpha = 0.4;
eta = 0.25;

r = 10;
w = 5;

p = 20;

%% Ítem a): Grillas

% Definimos el número de valores que queremos para cada grilla:

Nk = 200;
Nl = 200;

% Creamos las grillas:

K_grid = linspace(0,100, Nk);
L_grid = linspace(0,100, Nl);

%% Ítem b): Función "Production"

% Se crea la función solicitada en el archivo "Production.m". Note que esta
% función fue creada de forma que permite los inputs sean matrices.

%% Ítem c): Función objetivo

% Vamos a crear la función de la siguiente manera. Primero, vamos a
% transponer el vector fila de 200x1 que corresponde a la grilla del
% capital y lo repetiremos 200 veces. Ello nos dará una matriz de 200x200,
% la que toma un valor de la grilla del capital diferente en cada fila.
% Ello lo introducimos como primer argumento para la función Production.

% Luego hacemos el procedimiento análogo para el vector fila del trabajo e
% introducimos ello como segundo argumento de la función. 

% Finalmente ponemos los parámetros relevantes (alpha y eta) como el tercer
% y cuarto argumento de la función. 

% El output de tal función se guarda en Y, que será una matriz de 200x200 
% con su elemento ij el valor de F(K_i,L_j). 

Y = Production(repmat(K_grid', [1 Nl]), repmat(L_grid, [Nk 1]), alpha, eta);



% Ahora evaluaremos los costos. Para ello, hacemos el mismo procedimiento
% de crear matrices de 200x200 para el trabajo y el capital, pero
% simplemente las ponderamos por el costo del capital y el costo del
% trabajo, y las sumamos. 

% En "Costs" guardamos la matriz de 200x200, la que en su entrada ij 
% indicará el costo de la firma cuando el trabajo está en el nivel del
% j-ésimo elemento de L_grid y el capital está en el nivel del i-ésimo
% elemento de K_grid. 

Costs = repmat(K_grid', [1 Nl]) * r + repmat(L_grid, [Nk 1]) * w;

% Para llegar a la matriz "Profits" simplemente es necesario ponderar Y por
% el precio y restar los Costos.

Profits = p * Y - Costs;

%% Ítem d): nivel de trabajo con capital fijo en el decimoséptimo valor

% Creamos una matriz auxiliar que tenga los profits correspondientes a los
% diferentes valores del trabajo cuando K está en el decimoséptimo valor de
% la grilla. Esto es, simplemente la fila 17 de la matriz Profits:

Profits_K_fixed = Profits(17,:);

% Ahora encontramos el trabajo que maximiza las profits en tal nivel de
% capital. Es decir, debemos encontrar el índice donde la matriz alcanza su
% máximo y evaluar ese índice en la grilla del trabajo. Note que debemos
% buscar el máximo a través de columnas:

[~, L_opt_K_Fixed_index] = max(Profits_K_fixed, [], 2);

L_opt_K_Fixed = L_grid(L_opt_K_Fixed_index);


disp (['El nivel óptimo de trabajo es ' num2str(L_opt_K_Fixed)])

%% Ítem e): nivel de trabajo con capital fijo diferentes valores

% Vamos a hacer lo mismo que en el ítem anterior, pero ahora iterando sobre
% los diferentes niveles de capital posibles. 

% Primero debemos inicializar una matriz que llenaremos con el trabajo
% óptimo. Esta debe ser de 200x1 (o de 1x200) para capturar el óptimo para
% cada uno de los valores en que fijamos el capital.

L_opt = zeros(Nk,1);


for i = 1:Nk
    
    % Fijamos el capital, por lo que obtenemos el vector fila de la matriz
    % Profits:

    Profits_K_fixed = Profits(i,:);

    % Luego encontramos el índice donde el vector alcanza el máximo:

    [~, L_opt_K_Fixed_index] = max(Profits_K_fixed, [], 2);

    % Finalmente evaluamos en la grilla del trabajo y guardamos en la
    % i-ésima entrada de la matriz que inicializamos:

    L_opt(i,1) = L_grid(L_opt_K_Fixed_index);

end


% Para mejorar la exposición del resultado (no es necesario hacerlo),
% graficaré los resultados en el plano K-L:

figure(1)

plot(K_grid, L_opt, Color='red', LineStyle='-', LineWidth=2);
xlim([0,100])
ylim([0,100])
xlabel('$\bar{K}$', Interpreter='latex')
ylabel('$L^*$', Interpreter='latex')

%% Ítem f): nivel óptimo de capital y trabajo

% Debemos encontrar la entrada donde la matriz alcanza su máximo. Ahora
% bien, Matlab nos entragará un único índice, no un índice para las
% columnas y otro para las filas. Por ello, es necesario reinterpretar tal
% índice para tener un índice para las filas y otro para las columnas.

% Matlab genera tal índice vectorizando la matriz como un vector fila. Esto
% es, separa todas las columnas y luego las pone una encima de otra. Por
% tanto, para maximizar en dos dimensiones, nuestra matriz de 200x200 es
% transformada a un vector columna de 200^2 x 1, es decir, 40000 x 1. 

% Dado lo anterior, la columna que corresponde al índice entregado por 
% Matlab (llamémoslo por conveniencia idx) es la parte entera de 1 + idx / 200.
% Asimismo, la fila corresponde a idx - (col - 1)  * 200, donde "col" es la
% columna correspondiente.

[~,idx] = max(Profits, [], 'all');

Opt_col = 1 + floor(idx/Nl);

Opt_row = idx - (Opt_col - 1) * Nk;

% Los niveles óptimos de trabajo y capital serán los resultantes de evaluar
% el índice de las filas en la grilla del capital; y el índice de las
% columnas en la grilla del trabajo. 

L_opt = L_grid(Opt_col);
K_opt = L_grid(Opt_row);

disp (['El nivel óptimo de trabajo es ' num2str(L_opt)])

disp (['El nivel óptimo de capital es ' num2str(K_opt)])

% El nivel máximo de la función objetivo será:

Profits_opt = Profits(Opt_row,Opt_col);

disp (['El nivel de profits es ' num2str(Profits_opt)])

