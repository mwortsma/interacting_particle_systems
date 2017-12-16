function index = evolve_system(l,r,nu,T,p,q)
    X = zeros(T, 3);
    % Draw X(1,:) according to nu
    % TODO
    X(1,:) = rand(1,3) > 0.5;
    
    % Evolve X according to l and r
    
    for t = 1:T-1
        % Update X(t,2), the middle node.
        if X(t,2) == 1
            X(t+1,2) = rand(1) >= q;
        else
            X(t+1,2) = rand(1) < p*(X(t,1) + X(t,3));
        end

        % Update X(t,1), the left node.
        if X(t,1) == 1
            X(t+1,1) = rand(1) >= q;
        else
            prob_0 = r(t,mat_to_index([X(1:t,2), X(1:t,1)],t,2));
            if prob_0 < 0; prob_0 = 1/2; end
            Y = rand(1) > prob_0;
            X(t+1,1) = rand(1) < p*(X(t,2) + Y);
        end

        % Update X(t,3), the right node.
        if X(t,3) == 1
            X(t+1,3) = rand(1) >= q;
        else
            prob_0 = l(t,mat_to_index([X(1:t,3), X(1:t,2)],t,2));
            if prob_0 < 0; prob_0 = 1/2; end
            Z = rand(1) > prob_0;
            X(t+1,3) = rand(1) < p*(X(t,2) + Z);
        end
    end
    
    % Return the associated index
    index = mat_to_index(X,T,3);
end

