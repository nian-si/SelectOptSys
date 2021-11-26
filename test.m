p = 0.70:0.01:0.95;
n = length(p);
K = 16;
rec = zeros(K,n);
experiments = 2000;
parfor i = 1:n
    for k = 4:7  
        for j = 1:experiments     
            rec(k,i) = rec(k,i) + queue_run_once(k,p(i),K,2000);
        end  
    end
end
rec = rec / experiments;
figure
hold on
for i = 5:7
    plot(p,rec(i,:))   
end
legend('k=5','k=6','k=7')
hold off
max(rec,[],2)