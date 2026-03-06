function [V] = McCallSearch_VFI(beta,c)

w_min = 1;
w_max = 70;

n = 100;

w = linspace(w_min, w_max, n+1);

% Distribución Gamma para los posibles valores del salario


alpha = 4;
theta = 4;

n = 100;

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



%plot(w,q)

V0 = w'./(1-beta);

itermax = 10000;

epsilon = 1e-7;

for i = 1:itermax

    accion = zeros(n+1,2);

    for j = 1:n+1
        accion(j,:) = [w(j)/(1-beta), -c + beta * sum(V0.* q)];
    end

    Vn = max(accion, [], 2);

    d = max(abs(V0 - Vn));

    if d < epsilon
        V =  Vn;
        break
    else
        V0 = Vn;
    end

end

end