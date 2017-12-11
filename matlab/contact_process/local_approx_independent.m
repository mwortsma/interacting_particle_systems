function S = local_approx_independent(n,t_end,p,q)

% S(t,:) is the state at time t=1,..,t_end. S(1,:) is iid Bernoulli(init_p)
init_p = 0.5;
S = zeros(t_end,n);
S(1,:) = rand(1,n) <= init_p;


t = 1;
while t < t_end
    % Update each node
    for j = 1:n
        if S(t,j) == 1
            S(t+1,j) = rand(1) >= q;
        else
            sample = local_approx_independent(1,t,p,q);
            sample = sample(end);
            S(t+1,j) = rand(1) < 2*p*sample;
        end
    end
    
    t = t + 1;
end

end




