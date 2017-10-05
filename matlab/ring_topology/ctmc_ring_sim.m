function [S_vect, Qs, maxes] = ctmc_ring_sim(n,lam, k, t_end, make_plot, mm1, find_maxes)
%n = 600;
%lam = 0.95;
%t_end = 20;
%make_plot = false;

%k = 100;

% queues are initially empty
queues = zeros(n,1); M = zeros(k,1); M(1) = n; S = M/n;

maxes = zeros(n,1);

t = 0; tlim = t_end;

get_neighbors_index = @(i) 1 + [mod(i-2,n), mod(i-1,n), mod(i,n)];
get_rate = @(q,q_arr) lam*(q == min(q_arr))/(sum(q == q_arr));

 d = 3; dt = 0.01;
%[~, s_sim] = simulate_diffeq(k, lam, d, dt, tlim);

while t < tlim
    %% get entering rates
    if mm1
        entering_rates = ones(n,1)*lam;
    else
        entering_rates = zeros(n,1);
        for i = 1:length(queues)
            for neighbor_set = get_neighbors_index(i)
                neighbors = queues(get_neighbors_index(neighbor_set));
                entering_rates(i) = ...
                    entering_rates(i) + get_rate(queues(i), neighbors);
            end
        end
    end
    
    %% get leaving rates
    leaving_rates = queues > 0;
    
    %% Wait for ~ exp(\sum rates) seconds
    rates = [entering_rates; leaving_rates];
    sum_rates = sum(rates);
    delta_t = exprnd(1/sum_rates);
    t = t + delta_t;
    
    %% Make Jump
   jump = randsample(1:length(rates),1,true,rates/sum_rates);
   if jump > n
       jump = jump-n;
       M(queues(jump)+1) = M(queues(jump)+1) - 1;
       queues(jump) = queues(jump) - 1;
   else
       queues(jump) = queues(jump) + 1;
       M(queues(jump)+1) = M(queues(jump)+1) + 1;
   end
   S = M/n;
   
   %% Visualize S
   if make_plot
    clf
    hold on
    plot(S(1:20));
    % plot(queues);
    title(sprintf("t = %.2f", t));
   end
   
   if find_maxes
       maxes = max(queues, maxes);
   end
   pause(1e-10)
end
S_vect = S;
Qs = queues;
end
