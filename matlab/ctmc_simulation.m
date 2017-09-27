function err = ctmc_simulation(n,d,lam, t_end, make_plot)

k = 100;

% queues are initially empty
queues = zeros(n,1); M = zeros(k,1); M(1) = n; S = M/n;

t = 0; tlim = t_end; dt = 0.01;
[~, s_sim] = simulate_diffeq(k, lam, d, dt, tlim);

num_error_recordings = 0;
err = 0;

while t < tlim
    %% get entering rates
    entering_rates_for_each_s = ...
        lam * n *  (S(1:end-1).^d - S(2:end).^d) ./ (M(1:end-1) - M(2:end));
    % 1 added for 1-indexing
    entering_rates = entering_rates_for_each_s(1 + queues);
    
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
   end
   if floor(t/dt) >= 1 && floor(t/dt) <= size(s_sim,1)
       derr = max(abs(s_sim(floor(t/dt),:)' - S));
       err = err + derr;
       num_error_recordings = num_error_recordings + 1;
       if make_plot
            plot(s_sim(floor(t/dt),1:20));
            title(sprintf("simulation. t = %.2f, ptwise max err = %.5f",...
                t, derr));
       end
   end
   pause(1e-10)
end
err = err / num_error_recordings;
end