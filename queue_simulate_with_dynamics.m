function [val,n_customer,D,W] = queue_simulate_with_dynamics(temp_p, in_homo_poisson, service_time, patience_time, p, c, n_server1, n_server2)
keep = temp_p < (1-p);
arrival_time = in_homo_poisson(keep); 
n_customer = length(arrival_time);
service_time = service_time(keep,:);
patience_time = patience_time(keep);

D = 0;
W = 0;
arrival_time2 = zeros(n_customer,1);

% server 1
next_idle_time = zeros(1,n_server1);
for i = 1:n_customer
    [b_j,I] = min(next_idle_time);
    d = max(b_j + service_time(i,1), arrival_time(i) + service_time(i,1));
    w = d - arrival_time(i) - service_time(i,1);

    if(w > patience_time(i))
        continue
    end
    D = D + 1;
    arrival_time2(D) = d;
    W = W + w;
    next_idle_time(I) = d;
end
%
% server 2
arrival_time2 = arrival_time2(1:D);
sort(arrival_time2);
next_idle_time = zeros(1,n_server2);
for i = 1:D
    [b_j,I] = min(next_idle_time);
    d = max(b_j + service_time(i,2), arrival_time2(i) + service_time(i,2));
    w = d - arrival_time2(i) - service_time(i,2);
    W = W + w;
    next_idle_time(I) = d;
end

val = p * D - c * W;



    
