function [demand,p,c] =newsvendar_gen_data(index,T)
    p = 0.5 * index + 5;
    c = 0.2 * index + 1;
    demand = poissrnd( -6 * index + 250,T,1);
end