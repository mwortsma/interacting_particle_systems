% A script which demonstrates that the differential equation solution from
% the function 'simulate_diffeq' converges to the fixed point from the
% Mitzenmacher paper.

% Set parameters.
% k = # of diffeq to simulate (s_1,...,s_k)
% d = which values of d to solve for
% lam = rate parameter lambda.
k = 100; d_vec = [1 2 3]; lam = 0.95;

% which values of t to plot. Every timestep dt from 0 to t_end.
t_end = 100; dt = 0.5; t_vec = 0:dt:t_end;

% Form of fixed point equation from Mitzenmacher paper.
fixed_pt = @(d) lam.^((d.^(0:k-1) - 1)/(d-1));

% Simulations will be of demensions 
% (# of d values to plot) x (# of t values to plot) x (k)
simulations = zeros(length(d_vec), length(t_vec), k);
for i = 1:size(simulations,1)
    % for each value of d, call simulate_diffeq.
    [t, simulations(i,:,:)] = simulate_diffeq(k, lam, d_vec(i), dt, t_end);
end

% Code to make plotting easier.
y_axis_lim = 20;
sim_vec = @(d_index, t) ...
    reshape(simulations(d_index,t,1:y_axis_lim), [1,y_axis_lim]);

% Simulate for each t in t_vec
for t = 1:length(t_vec)
    clf
    hold on
    plot(sim_vec(1,t));
    plot(sim_vec(2,t));
    plot(sim_vec(3,t));
    plot(fixed_pt(2));
    plot(fixed_pt(3));
    axis([0 y_axis_lim 0 1]);
    title(sprintf(...
        'diff eq convergence to fixed pt sim. t = %.2f', t_vec(t)));
    legend('d = 1', 'd = 2', 'd = 3', 'd = 2 fixed pt', 'd = 3 fixed pt');
    pause(0.0001)
end


