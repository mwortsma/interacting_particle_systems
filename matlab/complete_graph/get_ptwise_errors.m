% Visualize the average max pointwise error for different values of n.

% Depricated, this script is no longer in use.

n_vals = [5 10 25 50 75 100 150 200 250 300 400 500 750 1000];
errs = zeros(length(n_vals),1);

for i = 1:length(n_vals)
    errs(i) = ctmc_simulation(n_vals(i),2,0.95,50,false);
    disp(n_vals(i)); 
end

plot(n_vals,errs)
ylabel('average of the max pointwise error')
xlabel('number of queues');
legend('avg max pointwise error');