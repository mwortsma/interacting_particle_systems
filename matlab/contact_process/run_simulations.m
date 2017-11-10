%% Parameters
num_iterations = 100000;
p = 1/3;
q = 1/3;
t_end = 4;
n = 100;
%% Obtain Full Simulation Data
full_sim_data = zeros(num_iterations*t_end, n);
index = 1;
for iter = 1:num_iterations
    S = full_simulation(t_end, p, q, n);
    full_sim_data(index:index+t_end-1,:) = S;
    index = index + t_end;
    disp(iter);
end
save('full_sim_data.mat', 'full_sim_data')

%% Obtain Full Simulation Data 2
full_sim_data2 = zeros(num_iterations*t_end, n);
index = 1;
for iter = 1:num_iterations
    S = full_simulation(t_end, p, q, n);
    full_sim_data2(index:index+t_end-1,:) = S;
    index = index + t_end;
    disp(iter);
end
save('full_sim_data2.mat', 'full_sim_data2')

%% Obtain Local Simulation Data
local_sim_data = zeros(num_iterations*t_end, 3);
index = 1;
for iter = 1:num_iterations
    S = local_approx_simulation(t_end, p, q);
    local_sim_data(index:index+t_end-1,:) = S;
    index = index + t_end;
    disp(iter);
end
save('local_sim_data.mat', 'local_sim_data')

%% Obtain Local Simulation Optimized Data
%local_sim_opt_data = zeros(num_iterations*t_end, 3);
%index = 1;
%for iter = 1:num_iterations
%    S = local_approx_simulation_optimized(t_end, p, q);
%    local_sim_opt_data(index:index+t_end-1,:) = S;
%    index = index + t_end;
%    disp(iter);
%end
%save('local_sim_opt_data.mat', 'local_sim_opt_data')
