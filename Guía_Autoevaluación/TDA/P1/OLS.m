function [beta] = OLS(X,Y)

% en el lado izquierdo hemos definido el output de la función, mientras que
% en el lado derecho especificamos los argumentos de ella. En este caso, X
% es una matriz de N x K, e Y es una matriz de N x 1.

    N = size(X,1); % N es el número de filas de X
    K = size(X,2); % K es el número de columnas de X
    aux = [ones(N,1), X]; % esta es la matriz X pero con una columna de
                          % unos. Ello permite incorporar el intercepto.

    beta = (aux'*aux)\aux'*Y; % beta es el vector de coeficientes estimados.
end