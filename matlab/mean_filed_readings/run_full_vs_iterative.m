function [mu, typical_distribution] = run_full_vs_iterative(N, full_system_iters, tau,beta,h, ~)
    %% Fixed Point Solution
    f = ones(length(tau), 2)*(1/2);
    nu = [1/2, 1/2];

    fixed_pt_iters = 100;
    fixed_pt_eps = 1e-4;

    [mu, res] = iterative_fixed_pt_cw(tau, nu, f, N, beta, h, fixed_pt_iters, fixed_pt_eps);
    disp(length(res))


    %% Evolving the Full System
    j = 1;
    typical_distribution = full_cw(N,length(tau),h,beta,j,full_system_iters);

    if nargin > 5
        hold on;
        plot(mu(:,1))
        plot(typical_distribution(:,1))
    end

end