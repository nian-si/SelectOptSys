function OCBA(type, K_list)
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


K_optimal = zeros(length(K_list),1);


if(type == 2)
    optimal_map = containers.Map([16,24,32,40,128],[9,12,16,20,65]);
    for i = 1:length(K_list)
        K_optimal(i) = optimal_map(K_list(i));
    end
    Length_T = 2000;
    p = 0.1:0.1:1;
    Length_p = length(p);
    T_list = T_list * 2;
end
if (type == 3)
    load('dose_sys.mat');
    K_optimal3 = zeros(1,length(K_list));
    for i = 1:length(K_list)
        [~,K_optimal3(i)] = min(opt_list(1:K_list(i),1));
    end
    p = 11:1:40;
    Length_p = length(p);
    T_list = T_list * 2;
end

cor_rec = zeros(length(T_list),length(K_list));
for K_i = 1:length(K_list)
    for T_i = 1:length(T_list)
        T = T_list(T_i);
        K = K_list(K_i);
        N_0 = max(2,ceil(T / K / Length_p  / 5));
        correct = 0;
        cur_optimal = K_optimal(K_i);
        parfor experiment = 1:experiments
            hat_mu = zeros(K,Length_p);
            hat_sigma = zeros(K,Length_p);

            for index = 1:K
                for i = 1:Length_p
                    rec = zeros(1,N_0);
                    for j = 1:N_0
                        if (type == 2)
                            rec(j) = queue_run_once(index,p(i),K,Length_T); 
                        elseif (type == 3)
                            rec(j) = -dose_once(index,p(i),systems);
                        end
                    end
                    hat_mu(index,i) = mean(rec);
                    hat_sigma(index,i) = std(rec);
                end
            end
            cur_t = K * N_0 * Length_p;
            N_i = ones(K,Length_p) * N_0;
            for t = (cur_t + 1) : T
                [~,p_b] = max(max(hat_mu));
                [~,K_b] = max(hat_mu(:,p_b));
                beta = hat_sigma.^2./ (hat_mu - hat_mu(K_b,p_b)).^2;
                beta(K_b,p_b) = 0;
                beta(K_b,p_b) = hat_sigma(K_b,p_b) .* sqrt(sum(sum(beta.^2 ./ (hat_sigma.^2) ) ) );
                temp = beta./N_i;
                [~,selected_p] = max(max(temp));
                [~,selected_index] = max(temp(:,selected_p));
                x = 0;
                if type == 2
                    x = queue_run_once(selected_index,selected_p,K,Length_T); 
                elseif type == 3
                    x = -dose_once(selected_index,selected_p,systems);
                end

                cur_N = N_i(selected_index,selected_p);
                hat_mu_before = hat_mu(selected_index,selected_p);
                hat_sigma_before = hat_sigma(selected_index,selected_p);
                hat_mu(selected_index,selected_p) = hat_mu_before * (cur_N  + x) /(cur_N  + 1);
                hat_sigma(selected_index,selected_p) = sqrt((hat_sigma_before^2 * (cur_N  - 1) + x^2 + cur_N  * hat_mu_before^2  - (cur_N  + 1)* hat_mu(selected_index,selected_p)^2)/ cur_N);
                N_i(selected_index,selected_p) = cur_N + 1;
            end
            [~,p_b] = max(max(hat_mu));
            [~,K_b] = max(hat_mu(:,p_b));
            if  K_b == cur_optimal  
                correct = correct + 1;
            end
%             if (mod(experiment,10) == 0) 
%                 format shortg
%                 [K,T,experiment,K_b,p_b]  
%             end
        end
        [K,T,correct]
        cor_rec(T_i,K_i) = correct / experiments;
        save(strcat('data_OCBA_',type_name{type},'_K',num2str( K_list,'_%d'),'.mat'))
    end
end

%save('data_OCBA.mat')
    
    

