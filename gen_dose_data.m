% Generate dose data
rng(1234)
clear;
K = 128;
a = 9/50/25;
b = (-7 - 25^2 * a) / 25;
c = -5;
col = [a,b,c];
a2 = 13/50/25;
b2 = (-11 - 25^2 *a)/25;
c2 = -7;
randnum = rand(K,3) * 0.2 - 0.1;
temp = rand(K,1) * 0.2 - 0.1;
randnum = [temp,temp,temp];
systems = (1 + randnum) .* col;
opt_list = zeros(K,2);
for i = 1:K
    opt_list(i,2) = -systems(i,2) / 2 / systems(i,1);
    opt_list(i,1) = systems(i,3) - systems(i,2)^2/4/systems(i,1);
end
save("dose_sys.mat");
 