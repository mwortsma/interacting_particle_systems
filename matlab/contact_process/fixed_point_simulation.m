function [mu, residuals] = fixed_point_simulation(T,p,q)
    f = rand(1,2^(3*T));
    % make sure that the 0th marginal is equal in distribution to nu.
    % TODO
    f = f /sum(f);
    
    alg_iterations = 10;
    epsilon = 0.005;
    
    residuals = zeros(alg_iterations,1);
    
    for alg_iter = 1:alg_iterations
        f_new = fixed_pt_simulation_one_step(f, T, 0, 1000000,p,q);
        residuals(alg_iter) = norm(f_new - f);
        disp(alg_iter); 
        disp(residuals(alg_iter));
        if residuals(alg_iter) < epsilon; break; end
        f = f_new;
    end
    mu = f_new;
end