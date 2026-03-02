function [root, iter] = NR(f, x_0)

% Criterio de tolerancia:

eps = 10^-10;

% Número máximo de iteraciones

itermax = 1000;

% Se establece el guess inicia

x_i = x_0;

for i = 1:itermax
    x_i1 = step_n(f,x_i);
    if abs(x_i1 - x_i)<eps
        root = round(x_i, 5);
        iter = i;
        break
    else
        x_i = x_i1;
    end
end

% El loop hace lo siguiente. A partir del guess x_0, calcula el step con la
% función step_n. Luego chequea si se cumple el criterio de tolerancia. Si
% se cumple, establece como solución a x_i. En otro caso, realiza el step y
% se vuelve a repetir el algoritmo.

end