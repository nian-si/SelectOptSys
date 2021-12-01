function main_uniform(type, K_list)
if nargin == 0
    type = 2;
    K_list = [16,24,32,40];
   
elseif nargin == 1
    K_list = [16,24,32,40];
end

if type == 1
    T_list = [250000,500000,1000000,1500000,2000000,2500000,3000000,3500000,4000000];
elseif type == 2
    T_list = [2500,5000,10000,15000,20000,25000,30000,35000,40000];
else 
    T_list = [2500,5000:5000:80000];
end

if (K_list(1) == 128 && type ~= 1)
    T_list = T_list * 2;
end
        
% type: 1 for newsvendor; 2 for queueing; 3 for dosage
experiments = 1000;


type_name = {'newsvendor','Queueing','dose'};


stepsize_const = 2;
K_optimal = zeros(length(K_list),1);
if type == 1
    K_optimal = 14 * ones(length(K_list),1);
elseif type == 2
    optimal_map = containers.Map([16,24,32,40,128],[9,12,16,20,65]);
    for i = 1:length(K_list)
        K_optimal(i) = optimal_map(K_list(i));
    end

elseif (type == 3)
    load('dose_sys.mat');
    for i = 1:length(K_list)
        [~,K_optimal(i)] = min(opt_list(1:K_list(i),1));
    end
end




cor_rec = zeros(length(T_list),length(K_list));


tic
for  K_i= 1:length(K_list)
    for  T_i= 1:length(T_list)
        T = T_list(T_i); % T = 10000 for Queuing; T = 500000 for newsvendar
        K = K_list(K_i);
        L = 1;
        correct = 0;
        cur_optimal = K_optimal(K_i);
       
        parfor experiment = 1:experiments
            cur_K = K;
            val_K = zeros(K,2);
            val_K(:,2) = 1:cur_K;
            for level = 1:L
                T_l = floor(T/cur_K/L);
                for j = 1:cur_K
                    if(type == 2)
                        [val_K(j,1),opt_sol,avg_n_customer,avg_D,avg_W] = run_system(val_K(j,2),type,T_l,K,[stepsize_const]);
                    elseif type == 3
                        [val_K(j,1),opt_sol] = run_system(val_K(j,2),type,T_l,K,[],systems);
                        val_K(j,1) = -val_K(j,1);
                    else
                        [val_K(j,1),opt_sol] = run_system(val_K(j,2),type,T_l);
                    end
                    %[val_K(j,2),opt_sol,avg_n_customer,avg_D,avg_W]
                end
                val_K = -sortrows(-val_K);
                cur_K = cur_K/2;
                
            end
            if val_K(1,2) == cur_optimal
                correct = correct + 1;
            end
%             if( mod(experiment,10) == 0)
%                 format shortg
%                 [K,T,experiment,val_K(1,1),val_K(1,2)]
%             end
            
            
        end
        
        type_name{type}
        format shortg
        [K,T,correct / experiments]
        cor_rec(T_i,K_i) = correct / experiments;
        save(strcat('data_uniform_',type_name{type},'_K',num2str( K_list,'_%d'),'.mat'))
    end
end
toc
cor_rec
