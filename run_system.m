function [val,opt_sol,avg_n_customer,avg_D,avg_W] = run_system(index,type,T,K,other_para,systems_data) 
% type: 1 for newsvendar; 2 for queueing; 3 for dose
if type == 1
    [demand,p,c] = newsvendar_gen_data(index,T);
    q = quantile(demand,(p-c)/p);
    val = mean(p * min(q,demand)) - c * q;
    opt_sol = q;
elseif type == 2
    stepsize_const = other_para(1);
    val = 0;
    opt_sol = 0;
    x = 0.5;
    Length_T = 2000;
    step_size = stepsize_const / sqrt(T)/ Length_T;
    avg_n_customer = 0;
    avg_D = 0;
    avg_W = 0;
    for i = 1:T
    
        [cur_val,cur_grad,n_customer,D,W] = queue_run_once(index,x,K,Length_T);
        
        val = val + cur_val;
        opt_sol = opt_sol + x;
        x = x + step_size * cur_grad;
        avg_n_customer = avg_n_customer + n_customer;
        avg_D = avg_D + D;
        avg_W = avg_W + W;
    end
    val = val/T;
    opt_sol = opt_sol/T;
    avg_n_customer = avg_n_customer/T;
    avg_D = avg_D/T;
    avg_W = avg_W/T;
elseif type == 3
    val = 0;
    opt_sol = 0;
    x = 25;
    step_size = 1 / sqrt(T);
    for i = 1:T
    
        [cur_val,cur_grad] = dose_once(index,x,systems_data);
        val = val + cur_val;
        opt_sol = opt_sol + x;
        x = x - step_size * cur_grad;
        
    end
    val = val/T;
    opt_sol = opt_sol/T;   
else
    disp "Wrong type!";
end