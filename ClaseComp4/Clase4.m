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

                           % Material para la Clase IV

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% Pregunta 1: Modelo de búsqueda

cd("/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/ClaseComp4")
%addpath("Figuras/")
%addpath("Funciones/")
clear
clc


%%
w_min = 1;
w_max = 70;

n = 100;

% Grilla del salario:

w = linspace(w_min, w_max, n+1);

% Generamos la p.d.f. de la distribución Gamma según los parámetros
% descritos:

alpha = 4;
theta = 4;


% Inicializamos un vector para guardar los valores de la p.d.f.

%q = zeros(n+1,1);

q = zeros(n+1,1);

% Con el loop obtenemos la p.d.f. (podríamos hacerlo de una manera más
% eficiente, no nos vamos a preocupar de ello ahora).

%for i = 0:n
%    q(i+1,1) = gampdf(i,alpha,theta);
%end

q(1) = gamcdf(w(:,1), alpha, theta);

% Ahora usamos un loop para completar el vector hasta la componente n-1:

for k = 2:n

    q(k) = gamcdf(w(:,k), alpha, theta) - ...
              gamcdf(w(:,k-1), alpha, theta);


end

q(n+1) = 1 - gamcdf(w(:,n+1), alpha, theta);

% Imponemos los valores de c y de beta:

c = -10;

beta = 0.99;

% El c<0 se interpreta como un "seguro de cesantía", un ingreso al que el
% agente puede acceder en caso de no trabajar.

% Mínimo y máximo del salario:


% Grilla del salario:

%w = linspace(w_min, w_max, n+1);

% Graficamos la distribución de w:

figure(1)
plot(w,q, LineStyle='-', LineWidth=2, Color='red')
title('Densidad de probabilidad de w')
xlabel('w', Interpreter='latex')
ylabel('q(w)', Interpreter='latex')

%% VFI

% Guess inicial

V0 = zeros(n+1,1);

% Número máximo de iteraciones:

itermax = 10000;

% Parámetro de precisión:

epsilon = 1e-7;

for i = 1:itermax

    accion = zeros(n+1,2); % Inicializamos el matriz para guardar los 
                           % valores de las acciones a realizar
    
    % Se guarda el valor de cada posible acción condicional a V_0
    
    for j = 1:n+1
        accion(j,:) = [w(j)/(1-beta), -c + beta * sum(V0.* q)];
    end
    
    % Se encuentra la opción óptima:

    Vn = max(accion, [], 2);

    % Distancia

    d = max(abs(V0 - Vn));

    % Criterio de convergencia:

    if d < epsilon
        V =  Vn;
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        break
    else
        V0 = Vn;
    end

end

% El salario de reserva es:

wr = (1-beta) * (- c + beta * sum(V.* q));

% Graficamos

figure(2)
plot(w,V, '-.', LineWidth=2, color='#0c79c4'); hold on
xline(wr, '-', LineWidth=1, color = '#e92427');
title('Función valor')
xlabel('$w$', Interpreter='latex')
ylabel('$v(w)$', Interpreter='latex')

%% Estática comparativa utilizando la función

c_grid = linspace(-15,5,20);

nc = size(c_grid,2);

beta_grid = linspace(0.9,0.999, 20);

nb = size(beta_grid,2);

V_grid = zeros(nb,nc,n+1);
rw_grid = zeros(nb,nc);

for i = 1:nb
    for j = 1:nc
        V = McCallSearch_VFI(beta_grid(i), c_grid(j))';
        V_grid(i,j,:) = V;
        rw_grid(i,j) = (1-beta_grid(i)) * (-c_grid(j) + beta_grid(i) * sum(V' .* q));
    end
end

%%

figure(3)
contourf(c_grid, beta_grid, rw_grid, 'LineStyle', 'none'); % 'LineStyle', 'none' para eliminar las líneas de contorno
xlabel('$c$', Interpreter='latex');
ylabel('$\beta$', Interpreter='latex');
title('Salario de reserva','interpret','latex');
colorbar; % Agregar una barra de color para interpretación visual


figure(4)

surf(c_grid, beta_grid, rw_grid);
colorbar; 
xlabel('c','interpret','latex');
ylabel('$\beta$', Interpreter='latex');
zlabel('Salario de reserva','interpret','latex');
title('Salario de reserva (3D)','interpret','latex');





%% Pregunta 2: Modelo de búsqueda con learning

cd("/Users/afl/Library/CloudStorage/Dropbox/Universidad/Sexto año/Ayudantias_O2026/Dynamic_Programming/ClaseComp4")

clear
clc

% Fijamos n y otros parámetros:

n = 200;
beta = 0.87;
c = 20;

% Valores máximos y grilla de w:

w_min = 1;
w_max = 100;
w_grid = linspace(w_min, w_max, n);



% Generamos la p.d.f. de la distribución Gamma según los parámetros
% descritos:

alpha_f = 5;
theta_f = 3.5;

alpha_g = 22;
theta_g = 2.2;





% Con el loop obtenemos la p.d.f. (podríamos hacerlo de una manera más
% eficiente, no nos vamos a preocupar de ello ahora).

Pr_f = zeros(1,n);

Pr_g = zeros(1,n);

% Antes de usar un loop, seteamos el valor de Pr(w = w_1):


Pr_f(:,1) = gamcdf(w_grid(:,1), alpha_f, theta_f);
Pr_g(:,1) = gamcdf(w_grid(:,1), alpha_g, theta_g);

% Ahora usamos un loop para completar el vector hasta la componente n-1:

for k = 2:n-1

    Pr_f(:,k) = gamcdf(w_grid(:,k), alpha_f, theta_f) - ...
              gamcdf(w_grid(:,k-1), alpha_f, theta_f);

    Pr_g(:,k) = gamcdf(w_grid(:,k), alpha_g, theta_g) - ...
              gamcdf(w_grid(:,k-1), alpha_g, theta_g);

end

Pr_f(:,n) = 1 - gamcdf(w_grid(:,n), alpha_f, theta_f);

Pr_g(:,n) = 1 - gamcdf(w_grid(:,n), alpha_g, theta_g);



% Graficamos las distribuciones de w:

figure(1)
plot(w_grid,Pr_f, LineStyle='-', LineWidth=2, Color='red'); hold on
plot(w_grid,Pr_g, LineStyle='-', LineWidth=2, Color='blue'); hold on
title('Densidad de probabilidad de w')
xlabel('w', Interpreter='latex')
ylabel('q(w)', Interpreter='latex')
legend('$f(w)$', '$g(w)$', Interpreter = 'latex')


%% VFI usando pi = 0.5

% Número máximo de iteraciones:

itermax = 10000;

% Parámetro de precisión:

epsilon = 1e-7;

pi = 0.5;

% Guess para V:

V = zeros(n,1);


for i = 1:itermax
    
    % Vector para guardar el valor de cada decisión para cada posible valor 
    % de w. Note que la segunda columna (que es el segundo argumento de la 
    % función máx de la ecuación de Bellman) no depende de w:
    
    decision = [w_grid' / (1-beta), ...
               repmat(-c + beta * (Pr_f * pi + (1-pi) * Pr_g) * V,[n,1])];
    
    % Encontramos la decisión óptima para cada posible valor de w:

    [Vn, pol] = max(decision,[], 2);

    % Condición de convergencia:

    if abs(max(Vn - V)) < epsilon
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V =  Vn;
        break
    else
        V = Vn;
    end
end



figure(2)
plot(w_grid,V, '-.', LineWidth=2, color='#0c79c4'); hold on
title('Función valor')
xlabel('$w$', Interpreter='latex')
ylabel('$v(w)$', Interpreter='latex')
ylim([200,1700])




%% VFI con pi como estado


% Número máximo de iteraciones:

itermax = 10000;

% Parámetro de precisión:

epsilon = 1e-10;

pi_grid = linspace(0.01, 0.99, 50);
npi = size(pi_grid, 2);


V = zeros(n,npi);


V_iter = zeros(n,npi);
tic
for i = 1:itermax
    
    % Vector para guardar el valor de cada decisión para cada posible valor 
    % de w. Note que la segunda columna (que es el segundo argumento de la 
    % función máx de la ecuación de Bellman) no depende de w:
    for j = 1:npi
        pi = pi_grid(j);
        decision = [w_grid' / (1-beta), ...
                    repmat(-c + beta * (Pr_f * pi + (1-pi) * Pr_g) * V,[n,1])];

        [Vn(:,j), pol(:,j)] = max(decision,[], 2);
    end


    % Condición de convergencia:

    if max(max(abs(Vn - V))) < eps
        fprintf("\n El procedimiento iterativo de la función valor converge en la iteración número %g \n", i)
        V =  Vn;
        break
    else
        V = Vn;
    end
end
toc


figure(3)
contourf(pi_grid, w_grid, pol, 'LineStyle', 'none');
xlabel('$\pi$', Interpreter='latex');
ylabel('$w$', Interpreter='latex');
title('Decisión óptima','interpret','latex');
text(0.8,75,'Acepta', Color='white'); 
text(0.2,20,'Rechaza', Color='black'); 

