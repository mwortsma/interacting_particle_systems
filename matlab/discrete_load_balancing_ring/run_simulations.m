%% Parameters
num_iterations = 100000;
n = 50;
t_end = 2;
lam = 0.9;
%% Obtain Full Simulation Data
full_sim_data = zeros(num_iterations*t_end, n);
index = 1;
for iter = 1:num_iterations
    S = full_simulation(n, lam, t_end);
    full_sim_data(index:index+t_end-1,:) = S;
    index = index + t_end;
    disp(iter);
end
save('full_sim_data.mat', 'full_sim_data')

%% Obtain Full Simulation Data 2
full_sim_data2 = zeros(num_iterations*t_end, n);
index = 1;
for iter = 1:num_iterations
    S = full_simulation(n, lam, t_end);
    full_sim_data2(index:index+t_end-1,:) = S;
    index = index + t_end;
    disp(iter);
end
save('full_sim_data2.mat', 'full_sim_data2')

%% Obtain Local Simulation Data
local_sim_data = zeros(num_iterations*t_end, 5);
index = 1;
for iter = 1:num_iterations
    S = local_simulation(lam, t_end);
    local_sim_data(index:index+t_end-1,:) = S(:, 4:8);
    index = index + t_end;
    disp(iter);
end
save('local_sim_data.mat', 'local_sim_data')
