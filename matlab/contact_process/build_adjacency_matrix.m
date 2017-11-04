function G = build_adjacency_matrix(n, type)
    if strcmp(type, 'complete')
        G = complete_graph(n);
    elseif strcmp(type, 'ring')
        G = ring_graph(n);
    end
end

function G = complete_graph(n)
    G = ones(n,n);
    G(1:n+1:end) = 0;
end

function G = ring_graph(n)
    G = zeros(n,n);
    G(2:n+1:end) = 1;
    G(n+1:n+1:end) = 1;
    G(1,n) = 1; G(n,1) = 1;
end
    
