experiments = 100;
type = 1; % 1 for newsvendor 2 for queueing
correct = 0;
tic
for experiment = 1:experiments
    T = 500000; % T = 10000 for Queuing
    K = 16;
    L = log2(K);
    %L = 1;
    cur_K = 16;
    val_K = zeros(K,2);
    val_K(:,2) = 1:cur_K;
    for level = 1:L
        T_l = floor(T/cur_K/L);
        for j = 1:cur_K
            if(type == 2)
                [val_K(j,1),opt_sol,avg_n_customer,avg_D,avg_W] = run_system(val_K(j,2),type,T_l,K);
            else
                [val_K(j,1),opt_sol] = run_system(val_K(j,2),type,T_l);
            end
            %[val_K(j,2),opt_sol,avg_n_customer,avg_D,avg_W]
        end
        val_K = -sortrows(-val_K);
        cur_K = cur_K/2;
    end
    if type == 2 && val_K(1,2) == 6
        correct = correct + 1;
    end
    if type == 1 && val_K(1,2) == 14
        correct = correct + 1;
    end
    [experiment,val_K(1,1),val_K(1,2)]
end
toc
correct 
