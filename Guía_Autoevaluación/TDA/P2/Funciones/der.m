function [dydx] = der(f,x_0)

h = 10^(-5); 

dydx = (f(x_0 + h) - f(x_0))/h;

end