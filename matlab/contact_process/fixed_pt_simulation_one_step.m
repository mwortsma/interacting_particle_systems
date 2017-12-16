function f_new = fixed_pt_simulation_one_step(f, T, nu, iters,p,q)
    [l, r] = get_conditional_distributions(f, T);
    f_new = zeros(1, 2^(3*T));
    
    % Do this empirically.
    inc = 1/iters;
    for iter = 1:iters
        index = evolve_system(l,r,nu,T,p,q);
        f_new(index) = f_new(index) + inc;
    end
end