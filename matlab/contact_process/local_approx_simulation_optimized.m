function S = local_approx_simulation_optimized(t_end,p,q)
% Only run with the first three arguments.

% S(t,:) is the state at time t=1,..,t_end. S(1,:) is iid Bernoulli(init_p)
init_p = 0.5;
S = zeros(t_end,3);
S(1,:) = rand(1,3) <= init_p;

for t = 1:t_end-1
    % Update S(t,2), the middle node.
    if S(t,2) == 1
        S(t+1,2) = rand(1) >= q;
    else
        S(t+1,2) = rand(1) < p*(S(t,1) + S(t,3));
    end
    
    % Update S(t,1), the left node.
    if S(t,1) == 1
        S(t+1,1) = rand(1) >= q;
    else
        Y = local_approx_helper(t,p,q,S(1:t,1));
        S(t+1,1) = rand(1) < p*(S(t,2) + Y);
    end
    
    % Update S(t,3), the right node.
    if S(t,3) == 1
        S(t+1,3) = rand(1) >= q;
    else
        Z = local_approx_helper(t,p,q,S(1:t,3));
        S(t+1,3) = rand(1) < p*(S(t,2) + Z);
    end
end

end

function out = local_approx_helper(t_end, p, q, middle_node_vals)

init_p = 0.5;
S = zeros(t_end,1);
S(1) = rand(1) <= init_p;

for t = 1:t_end-1
    if S(t) == 1
        S(t+1) = rand(1) >= q;
    else
        W = local_approx_helper(t, p, q, S);
        S(t+1) = rand(1) < p*(middle_node_vals(t) + W);
    end
    
end

out = S(t_end);

end


