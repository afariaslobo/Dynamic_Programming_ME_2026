function [step] = step_n(f, x_0)

step = x_0 - f(x_0)/der(f,x_0);

end