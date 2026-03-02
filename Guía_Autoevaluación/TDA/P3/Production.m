function [Y] = Production(K,L,alpha,eta)
    
    Y = (K .^ alpha ) .* (L .^ eta);

    
end