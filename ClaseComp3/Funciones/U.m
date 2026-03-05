function [Uc] = U(C,sigma)
    if sigma == 1
        Uc = log(C);
    elseif sigma > 0
        Uc = (C.^(1 - sigma) - 1)/(1-sigma);
    end

    Uc(C < 0) = -1e11;
end