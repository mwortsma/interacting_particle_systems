k = 100; d_vec = [1 2 3]; lam = 0.95;
t_end = 100; dt = 0.5; t_vec = 0:dt:t_end;
fixed_pt = @(d) lam.^((d.^(0:k-1) - 1)/(d-1));

simulations = zeros(length(d_vec), length(t_vec), k);
for i = 1:size(simulations,1)
    [t, simulations(i,:,:)] = simulate_diffeq(k, lam, d_vec(i), dt, t_end);
end

y_axis_lim = 20;
sim_vec = @(d_index, t) ...
    reshape(simulations(d_index,t,1:y_axis_lim), [1,y_axis_lim]);

for t = 1:length(t_vec)
    clf
    hold on
    plot(sim_vec(1,t));
    plot(sim_vec(2,t));
    plot(sim_vec(3,t));
    plot(fixed_pt(2));
    plot(fixed_pt(3));
    axis([0 y_axis_lim 0 1]);
    title(sprintf('diff eq convergence to fixed pt sim. t = %.2f',...
        t_vec(t)));
    legend('d = 1', 'd = 2', 'd = 3', 'd = 2 fixed pt', 'd = 3 fixed pt');
    pause(0.0001)
end


