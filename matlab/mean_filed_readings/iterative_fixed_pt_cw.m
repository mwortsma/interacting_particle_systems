function [mu, res] = iterative_fixed_pt_cw(tau, nu, f, N, beta, h, iters, eps)
    res = zeros(1,length(iters));
    for i = 1:iters
        mu = evolve_cw_markov_chain(tau, nu, f, N, beta, h);
        res(i) = norm(mu - f);
        f = mu;
        if res(i) < eps; break; end
    end
end

function g = evolve_cw_markov_chain(tau, nu, f, N, beta, h)
    g = zeros(length(tau), 2);
    g(1,:) = nu;
    for t = tau
        if t == 1; continue; end
        g(t,:) = ...
            evolve_cw_markov_chain_one_step(g(t-1,:),f(t,:), N, beta, h);
    end
end

function u_new = evolve_cw_markov_chain_one_step(u_old,f_t, N, beta, h)
    m = f_t(2) - f_t(1);
    pos_to_neg = p_switch(m, m - 2/N, N, beta, h);
    neg_to_pos = p_switch(m, m + 2/N, N, beta, h);
    u_new = [1-neg_to_pos, pos_to_neg; neg_to_pos, 1-pos_to_neg]*u_old';
end

function out = p_switch(m, m_new, N, beta, h)
    out = (1/N)*exp(-beta*N*max(E(m_new,h) - E(m,h), 0));
end

function out = E(m,h)
    out = -m^2/2 - h*m;
end