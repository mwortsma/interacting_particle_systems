function S = full_simulation(t_end, p, q, n)
%n = 500; % Number of nodes
%t_end = 100; % Number of steps to run the algorithm.

% S(t,:) is the state at time t=1,..,t_end. S(1,:) is iid Bernoulli(init_p)
init_p = 0.5;
S = zeros(t_end,n);
S(1,:) = rand(1,n) <= init_p;

% We represent a graph as an adjacency matrix.
% Second argument should be 'complete' or 'ring'
type = 'ring';
G = build_adjacency_matrix(n, type);
% max_deg = max(sum(G,2));

% paramenters
%q = 1/3; % recovery probability 0 <= q <= 1
%p = (2/3)/max_deg; % infection probability 0 <= p <= num_edges

for t = 1:t_end-1
    for j = 1:n
        if S(t,j) == 1
            S(t+1,j) = rand(1) >= q;
        else
            S(t+1,j) = rand(1) < p*S(t,:)*G(j,:)';
        end
    end
end
end

% Plot
% spy(sparse(S))
% xlabel('nodes')
% ylabel('time')
% title(sprintf('full contact process simulation: %s graph', type))

