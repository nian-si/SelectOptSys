function  [cur_val,cur_grad,n_customer,D,W] = queue_run_once(index,p,K,Length_T)
lambda0 = 1;
sigma1 = 1;
sigma2 = 1;
mu1 = log(6) + log(K);
mu2 = log(6) + log(K);
rho = 0.5;
n_server1 = index;
n_server2 = K + 1 - index;
beta_theta = 1; % 1 / beta 
beta_alpha = 2 * (mu1);
delta_p = 0.03;
c = 0.05;

% Generate homogeneous poisson process
inter_arrival_time = exprnd(1/lambda0, ceil(2 * Length_T * lambda0),1);

homo_poisson = cumsum(inter_arrival_time);
homo_poisson = homo_poisson(homo_poisson < Length_T);
assert(length(homo_poisson) < ceil(2 * Length_T * lambda0))
n_homo = length(homo_poisson);
% Generate inhomogeneous poisson process
temp = rand(n_homo,1);
keep = temp < (Length_T-homo_poisson).* homo_poisson / (Length_T^2);
in_homo_poisson = homo_poisson(keep);
n_customer_before_p = length(in_homo_poisson);


% service time
service_time = exp(mvnrnd([mu1,mu2],[sigma1^2,rho * sigma1 * sigma2;rho * sigma1 * sigma2,sigma2^2],n_customer_before_p));

% patience time
patience_time = gamrnd(beta_alpha,beta_theta,n_customer_before_p,1);
% see price
temp_p = rand(n_customer_before_p,1);
[cur_val,n_customer,D,W] = queue_simulate_with_dynamics(temp_p, in_homo_poisson, service_time, patience_time, p, c , n_server1, n_server2);
cur_val2 = queue_simulate_with_dynamics(temp_p, in_homo_poisson, service_time, patience_time, p - delta_p, c, n_server1, n_server2);

cur_grad = (cur_val - cur_val2)/delta_p;









