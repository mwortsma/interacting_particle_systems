addpath(genpath('../ring_topology/'))
addpath(genpath('../complete_graph/'))

lambdas = [0.6 0.7 0.8 0.9 0.99];
iters = length(lambdas);

cplt_data = zeros(iters,1);
ring_data = zeros(iters,1);
mm1_data = zeros(iters,1);
for iter = 1:iters
    [~, cplt_Q] = ctmc_simulation(500,2,lambdas(iter),20,false);
    [~, ring_Q] = ctmc_ring_sim(500,lambdas(iter),100, 20, false, false,1);
    [~, mm1_Q] = ctmc_ring_sim(500,lambdas(iter),100, 20, false, true,1);
    
    cplt_data(iter) = mean(cplt_Q);
    ring_data(iter) = mean(ring_Q);
    mm1_data(iter) = mean(mm1_Q);
    disp(iter)
end
hold on
plot(lambdas,cplt_data);
plot(lambdas,ring_data);
plot(lambdas,mm1_data);