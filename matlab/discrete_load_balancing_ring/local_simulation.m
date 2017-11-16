function X = local_simulation(n, lam, t_end)

X = zeros(t_end, 11);
% Initialization
X(1,:) = poissrnd(-log(1-lam),[1,11]);

get_neighbors_index = @(i) 1 + mod(i-2:i,n);

for t = 1:t_end-1
    
    arrivals = rand(1,11) < lam*(1/n);
    if arrivals(2) || arrivals(3)
        Y = local_simulation(n, lam, t);
        while ~(isequal(Y(1:t,6), X(1:t,3)) && ...
                isequal(Y(1:t,5), X(1:t,4)) && ...
                isequal(Y(1:t,4), X(1:t,5)) && ...
                isequal(Y(1:t,3), X(1:t,6)))
            Y = local_simulation(n, lam, t);
        end
        X(t,1) = Y(t,8);
        X(t,2) = Y(t,7);
    end
    if arrivals(9) || arrivals(10)
        Z = local_simulation(n, lam, t);
        while ~(isequal(Z(1:t,9), X(1:t,6)) && ...
                isequal(Z(1:t,8), X(1:t,7)) && ...
                isequal(Z(1:t,7), X(1:t,8)) && ...
                isequal(Z(1:t,6), X(1:t,9)))
            Z = local_simulation(n, lam, t);
        end
        X(t,9) = Z(t,5);
        X(t,10) = Z(t,4);
    end
    
    
    X(t+1,3:9) = X(t,3:9);
    for i = 2:10
        % Entering
        if arrivals(i)
            neighbor_index = get_neighbors_index(i);
            neighbor_lengths = X(t, neighbor_index);
            [~, j] = min(neighbor_lengths);
            min_neighbor = neighbor_index(j);
            X(t+1, min_neighbor) = X(t+1,min_neighbor) + 1;
        end
        % Exiting
        if rand < 1/(n) && X(t,i) > 0
            X(t+1,i) = X(t+1,i) - 1;
        end
    end
end

%figure(1)
%clf
%imagesc(X)
%colorbar

%figure(2)
%clf
%hold on
%plot(sum(X > 0, 2)/n)
%plot(ones(t_end,1)*lam)
end



