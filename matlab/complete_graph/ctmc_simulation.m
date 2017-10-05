function err = ctmc_simulation(n,d,lam, t_end, make_plot)
% Use a continuous time markov chain to simulate the complete graph.
% n = # of queues to use.
% d = how many choices.
% lam = rate parameter lambda.
% t_end = which value of time to end at.
% make_plot = true if you would like to see an animation and false if you
% would like the function to run fast.

% err returned is meant to be a metric of distance between the ctmc
% simulation and the ctmc solution. Error calculated at each timestep and
% then averaged. 

% Example usage is ctmc_simulation(100,3,0.95,10,true).

% How many values of S to keep track of, s_1,...,s_k.
k = 100;

% queues are initially empty. 
% M(i) = # of queues with >= i items.
% S(i) = M/n = ratio of queues with >= i items.
queues = zeros(n,1); M = zeros(k,1); M(1) = n; S = M/n;

% which values of t to plot. Every timestep dt from 0 to t_end.
t = 0; dt = 0.01;
% Get the diffeq simulation to compare with the ctmc simulation.
[~, s_sim] = simulate_diffeq(k, lam, d, dt, t_end);

% Keep track of error.
num_error_recordings = 0;
err = 0;

while t < t_end
    %% get entering rates
    entering_rates_for_each_s = ...
        lam * n *  (S(1:end-1).^d - S(2:end).^d) ./ (M(1:end-1) - M(2:end));
    % get the entering rate for each queue by indexing at the queue length.
    % 1 added for 1-indexing
    entering_rates = entering_rates_for_each_s(1 + queues);
    
    %% get leaving rates (1(queue length > 0))
    leaving_rates = queues > 0;
    
    %% Wait for ~ exp(\sum rates) seconds
    rates = [entering_rates; leaving_rates];
    sum_rates = sum(rates);
    delta_t = exprnd(1/sum_rates);
    t = t + delta_t;
    
    %% Make Jump
    % Sample each jump with probability distribution rates/sum_rates
   jump = randsample(1:length(rates),1,true,rates/sum_rates);
   
   % There are 2n jumps.
   if jump > n
       % jump > n corresponds to leaving a queue. Update queues and M.
       jump = jump-n;
       M(queues(jump)+1) = M(queues(jump)+1) - 1;
       queues(jump) = queues(jump) - 1;
   else
       % jump <= n corresponds to entering a queue. Update queues and M.
       queues(jump) = queues(jump) + 1;
       M(queues(jump)+1) = M(queues(jump)+1) + 1;
   end
   S = M/n;
   
   %% Visualize S if make_pot = true
   if make_plot
    clf
    hold on
    plot(S(1:20));
   end
   
   %% Caluclate Error and Plot Simulated Diffeq if make_plot = True.
   
   % Since t values are being drawing ~ exp distribution, each t value
   % does not necessarily correspond to a timestep in the differential 
   % equation simulation. Thus we compare to entry floor(t/dt) which
   % will be the closest simulation value. However, the if statement is
   % needed to check that this entry exists and is not out of range.
   if floor(t/dt) >= 1 && floor(t/dt) <= size(s_sim,1)
       
       % Error metric can be changed, for now it is being calculated as
       % err(t) = max_k abs( (diffeq_sim_s(k) - ctmc_sim(k)) )
       % then averaged at the end. 
       num_nonzero = sum(S > 0);
       derr = max(abs(...
           (s_sim(floor(t/dt),1:num_nonzero)'- S(1:num_nonzero))));
       err = err + derr;
       num_error_recordings = num_error_recordings + 1;
       
       % if make_plot is true then also plot the simulated diff_eq
       if make_plot
            plot(s_sim(floor(t/dt),1:20));
            title(sprintf("simulation. t = %.2f, ptwise max err = %.5f",...
                t, derr));
            legend('ctmc simulation', 'diffeq simulation')
       end
   end
   pause(1e-10)
end
% return the averaged error metric.
err = err / num_error_recordings;
end