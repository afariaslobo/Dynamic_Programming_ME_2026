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

                           % Material para la Clase II

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preliminar

% Limpiamos todo:

clear
clc

% Definimos el directorio a utilizar y las carpetas que nos interesan:

cd("/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/ClaseComp2")
addpath("Figuras/")

%% Definimos parámetros y grillas

% Definimos los parámetros


beta = 0.96;
epsilon = 1e-7;

% Creamos las grillas de x y de z:

x_grid = linspace(0.01,20,1000);

z_grid = [0.5, 1, 1.5];

% Creamos el vector pr, nx y nz:

pr = [1/3, 1/3, 1/3];

nx = size(x_grid,2);

nz = size(z_grid,2);

% Creamos la matriz de consumo. De la restricción del problema es fácil
% notar que c_t = x_t+1 - x_t, por lo que si definimos que las filas
% correspondan a cada valor posible de x y las columnas a cada posible valor
% de x':

%C = repmat(x_grid', [1 nx])- repmat(x_grid, [nx 1]); 

C = repmat(x_grid', [1 nx])- repmat(x_grid, [nx 1])*0.999999; 

% Para determinar la utilidad, obtenemos z_t*u(c) para cada valor de C y 
% cada valor de z_t. Para ello iteramos sobre z y utilizamos para cada z la
% la matriz de valores de consumo evaluada en la función log. Así, la 
% primera dimensión del arreglo tridimensional representa los valores de x;
% la segunda dimensión los valores de x'; y la tercera dimensión 
% representa los valores de z. Fijamos la utilidad en -10^10 cuando C<=0.

Uz = zeros(nx,nx,nz);

for z = 1:nz
    for i = 1:nx
        for j = 1:nx
            if C(i,j) > 0
                Uz(i,j,z) = log(C(i,j)) * z_grid(z);
            else 
                Uz(i,j,z) = -1e11;
            end
        end
    end
end


%% VFI


% Definimos el número máximo de iteraciones

itermax = 1000;

% Definimos el guess inicial para la función valor como una matriz de ceros
% e inicializamos dos matrices: una para guardar los valores de la función 
% valor y otra para guardar los valores de la policy function en cada 
% actualización. 

V0 = zeros(nx,nz);
Vn = zeros(nx,nz);
x_pol = zeros(nx,nz);

% Iniciamos iteraciones y tomamos el tiempo:

tic
for i = 1:itermax

    % A partir del guess inicial para v(x,z), obtenemos E[v(x,z)] para cada
    % x y z. Lo podemos hacer por fuera del loop de z porque z es i.i.d. En
    % otro caso, tendríamos que hacerlo dentro del loop.

    V0_exp = sum(V0 .* pr,2);
    
    % iteramos sobre los posibles valores de z:
    for z = 1:nz
        % en lugar de utilizar definir una matriz auxiliar, podemos ocupar
        % como argumento para la función max como definiríamos la matriz 
        % auxiliar para cada valor de z. 

        % Encontramos el valor de x' que maximiza T dado x y z,y el máximo
        % de T dado x y z
        [Vn(:,z), index] = max(Uz(:,:,z) + beta * repmat(V0_exp', [nx 1]),[],2);
        
        % función de política para x' dado x y z:
        x_pol(:,z) = x_grid(index);
    end
    
    % función de política para c dado x  y z
    c_pol = repmat(x_grid', [1 nz]) - x_pol;
    
    % distancia (esta vez encontramos el maximo dado x y dado z, por ello 
    % ocupamos doble la función max)

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



%% VFI Caso i.i.d. de una manera más eficiente, pero menos intuitiva

% Definimos el número máximo de iteraciones

itermax = 10000;

% Esta vez, en lugar de ocupar un loop sobre z en cada iteración, nos 
% ahorramos ello computando todo en tres dimensiones y encontrando el 
% maximo sobre una de esas dimensiones (la correspondiente a x'). Ello nos
% entregará un arreglo tridimensional de índices que es necesario pasar a
% dos dimensiones para llegar sin problemas a la policy function y a la
% función valor. Por tanto, inicializamos matrices para pasar tales
% arreglos tridimensionales a dos dimensiones. Adicionalmente definimos el
% guess inicial para v.

V0 = zeros(nx,nz);
idx = zeros(nx,nz);
V_n = zeros(nx,nz);

tic
for i = 1:itermax

    % obtenemos E[V0(x',z')]:
    V0_exp = sum(V0 .* pr,2);


    % Encontramos el valor de x' que maximiza T dado x y z; y el máximo
    % de T dado x y z:
    [Vn, index] = max(Uz + beta * repmat(V0_exp', [nx 1 nz]),[],2); 
    %Vn guarda el valor máximo, index guarda la posición donde se encuentra
    % x' que el arreglo tridimensional

    % pasamos los arreglos tridimensionales a matrices para poder trabajar
    % con ellos:
    for j = 1:nz
        V_n(:,j) = Vn(:,1,j);
        idx(:,j) = index(:,1,j);
    end

    % función de política para x':

    x_pol = x_grid(idx);                          

    % función de política para c dado x  y z

    c_pol = repmat(x_grid', [1 nz]) - x_pol;    

    % distancia:
    d = max(max(abs(V0 - V_n)));

    % condición de convergencia:
    if d < epsilon
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V = V_n; % guardamos la solución
        break % cerramos el loop
    else
        V0 = V_n; % en caso de no cumplir la condición, actualizamos el guess
    end 
end
toc
beep


%% Graficamos lo solicitado

% Gráfico para la función valor:

figure(1)

plot(x_grid,V(:,1), LineStyle="-", LineWidth=2); hold on
plot(x_grid,V(:,2), LineStyle="-", LineWidth=2); hold on
plot(x_grid,V(:,3), LineStyle="-", LineWidth=2); hold on
title('Función valor');
xlabel('$x$', Interpreter='latex');
ylabel('$g(x,z)$', Interpreter='latex');
legend('z = 0.5', 'z = 1', 'z = 1.5', Location='northwest');

saveas(1,'Figuras/V_iid.pdf')

% Gráfico para la función de política:

figure(2)

plot(x_grid,x_pol(:,1), LineStyle="-", LineWidth=2); hold on
plot(x_grid,x_pol(:,2), LineStyle="-", LineWidth=2); hold on
plot(x_grid,x_pol(:,3), LineStyle="-", LineWidth=2); hold on
plot(x_grid,x_grid, LineStyle="--", color = 'black', LineWidth = 0.5);
title('Función de política de x');
xlabel('$x$', Interpreter='latex');
ylabel('$g(x,z)$', Interpreter='latex');
legend('z = 0.5', 'z = 1', 'z = 1.5', 'Línea de 45 grados', Location='northwest');

saveas(2,'Figuras/xpol_iid.pdf')

figure(3)

plot(x_grid,c_pol(:,1), LineStyle="-", LineWidth=2); hold on
plot(x_grid,c_pol(:,2), LineStyle="-", LineWidth=2); hold on
plot(x_grid,c_pol(:,3), LineStyle="-", LineWidth=2); hold on
title('Función de política del consumo');
xlabel('$x$', Interpreter='latex');
ylabel('$c(x,z)$', Interpreter='latex');
legend('z = 0.5', 'z = 1', 'z = 1.5', Location='northwest');

saveas(3,'Figuras/cpol_iid.pdf')

%% Caso con z_t siguiendo una cadena de Markov

beta = 0.96;
epsilon = 1e-7;

% Creamos la grilla de x y de z:

x_grid = linspace(0.01,20,1000);

z_grid = [0.5, 1.5];

P = [0.8, 0.2; 0.2, 0.8];

nx = size(x_grid,2);

nz = size(z_grid,2);

C = repmat(x_grid', [1 nx])- repmat(x_grid, [nx 1])*0.999999; 

% Para determinar la utilidad, obtenemos z_t*u(c) para cada valor de C y 
% cada valor de z_t. Para ello iteramos sobre z y utilizamos para cada z la
% la matriz de valores de consumo evaluada en la función log. Así, la 
% primera dimensión del arreglo tridimensional representa los valores de x;
% la segunda dimensión los valores de x'; y la tercera dimensión 
% representa los valores de z. Fijamos la utilidad en -10^10 cuando C<=0.

Uz = zeros(nx,nx,nz);

for z = 1:nz
    for i = 1:nx
        for j = 1:nx
            if C(i,j) > 0
                Uz(i,j,z) = log(C(i,j)) * z_grid(z);
            else 
                Uz(i,j,z) = -1e11;
            end
        end
    end
end

% Guess inicial:

V0 = zeros(nx,nz);

% Inicializamos matrices para guardar las actualizaciones de la value
% function y la policy function:

Vn = zeros(nx,nz);
x_pol = zeros(nx,nz);

% Iniciamos iteraciones y tomamos el tiempo:

tic
for i = 1:itermax

    % A partir del guess inicial para v(x,z), obtenemos E[v(x',z')] para cada
    % x y z. En este caso, E[v(x',z') | z = 0.5) =/= E[v(x',z') | z = 1.5),
    % por lo que debemos obtener la esperanza condicional de V(x',z')
    % para cada z. Para ello utilizamos un loop e iteramos sobre los 
    % posibles valores de z:

    for z = 1:nz
        
        % Esperanza condicional de V(x',z'):

        V0_exp = sum(V0 .* P(z,:),2);

        % Encontramos el valor de x' que maximiza la matrix auxiliar dado x
        % y z,y el máximo de ella dado x y z:

        [Vn(:,z), index] = max(Uz(:,:,z) + beta * repmat(V0_exp', [nx 1]),[],2);
        
        % función de política:

        x_pol(:,z) = x_grid(index);

    end

    % función de política para el consumo:

    c_pol = repmat(x_grid',[1 nz]) - x_pol;


    % distancia (nuevamente ocupamos doble la función max):

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

%% Graficamos lo solicitado

figure(4)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(3,1,1)
plot(x_grid,V(:,1), LineStyle="-", LineWidth=2); hold on
plot(x_grid,V(:,2), LineStyle="-", LineWidth=2); hold on
title('Función valor');
xlabel('$x$', Interpreter='latex');
ylabel('$V(x,z)$', Interpreter='latex');
legend('z = 0.5', 'z = 1.5', Location='best');

subplot(3,1,2)
plot(x_grid,x_pol(:,1), LineStyle="-", LineWidth=2); hold on
plot(x_grid,x_pol(:,2), LineStyle="-", LineWidth=2); hold on
plot(x_grid,x_grid, LineStyle="--", color = 'black', LineWidth = 0.5);
title('Función de política');
xlabel('$x$', Interpreter='latex');
ylabel('$g(x,z)$', Interpreter='latex');
legend('z = 0.5',  'z = 1.5', 'Línea de 45 grados', Location='northwest');

subplot(3,1,3)
plot(x_grid,c_pol(:,1), LineStyle="-", LineWidth=2); hold on
plot(x_grid,c_pol(:,2), LineStyle="-", LineWidth=2); hold on
title('Función de política del consumo');
xlabel('$x$', Interpreter='latex');
ylabel('$g(x,z)$', Interpreter='latex');
legend('z = 0.5',  'z = 1.5', Location='northwest');

saveas(4,'Figuras/Plots_Markov.pdf')