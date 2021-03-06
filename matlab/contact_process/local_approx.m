function [S, match] = local_approx(t_end,p,q,match_cols,match_vals)
% Only run with the first three arguments.

% match_col and match_val are used in the recursive calls, as is the return
% parameter match, set below:
match = true;
% if match_col and match_val are set, then at each time step, we check to
% see that match_val(t,match_col) = S(t,match_col) so if we ever have any
% divergence we can set match = false and return.

% S(t,:) is the state at time t=1,..,t_end. S(1,:) is iid Bernoulli(init_p)
init_p = 0.5;
S = zeros(t_end,3);
S(1,:) = rand(1,3) <= init_p;

% Optimization: If given match vals, only sample one new initial point.
if nargin > 3
    S(1,match_cols) = match_vals(1,:);
end

for t = 1:t_end-1
    % Update S(t,2), the middle node.
    if S(t,2) == 1
        S(t+1,2) = rand(1) >= q;
    else
        S(t+1,2) = rand(1) < p*(S(t,1) + S(t,3));
    end
    
    % Optimization: Check for divergence
    if nargin > 3
        if S(t+1,2) ~= match_vals(t+1,(match_cols == 2))
            match = false;
            return
        end
    end
    
    % Update S(t,1), the left node.
    if S(t,1) == 1
        S(t+1,1) = rand(1) >= q;
    else
        while 1
            [Y, match] = local_approx(t,p,q,[1 2],[S(1:t,2), S(1:t,1)]);
            if match
                break
            end
        end
        S(t+1,1) = rand(1) < p*(S(t,2) + Y(t,3));
    end
    
    % Optimization: Check for divergence
    if nargin > 3 && sum(match_cols == 1) > 0
        if S(t+1,1) ~= match_vals(t+1,(match_cols == 1))
            match = false;
            return
        end
    end
    
    % Update S(t,3), the right node.
    if S(t,3) == 1
        S(t+1,3) = rand(1) >= q;
    else
        while 1
            [Z, match] = local_approx(t,p,q,[2 3],[S(1:t,3), S(1:t,2)]);
            if match
                break
            end
        end
        S(t+1,3) = rand(1) < p*(S(t,2) + Z(t,1));
    end
    
    % Optimization: Check for divergence
    if nargin > 3 && sum(match_cols == 3) > 0
        if S(t+1,match_cols) ~= match_vals(t+1,(match_cols == 3))
            match = false;
            return
        end
    end
end

end

