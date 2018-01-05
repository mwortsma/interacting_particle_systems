function X = full_simulation(n, lam, t_end)
%n = 1000; lam = 0.95; t_end = 500000;
X = zeros(t_end, n);

% Initialization
% X(1,:) = poissrnd(-log(1-lam),[1,n]);

get_neighbors_index = @(i) 1 + mod(i-2:i,n);

for t = 2:t_end
    for i = 1:n
        X(t,i) = X(t,i) + X(t-1,i);
        % Entering
        if rand < lam
            neighbor_index = get_neighbors_index(i);
            neighbor_lengths = X(t-1, neighbor_index);
            [~, j] = min(neighbor_lengths);
            min_neighbor = neighbor_index(j);
            X(t, min_neighbor) = X(t,min_neighbor) + 1;
        end
        % Exiting
        if X(t-1,i) > 0
            X(t,i) = X(t,i) - 1;
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




