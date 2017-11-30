function [X, match] = local_simulation(lam, t_end, match_cols, match_vals)

X = zeros(t_end, 11);
% Initialization
X(1,:) = poissrnd(-log(1-lam),[1,11]);
if nargin > 3
    X(1,match_cols) = match_vals(1,:);
end

match = false;

for t = 1:t_end-1
    
    arrivals = rand(1,11) < lam;
    if arrivals(2) || arrivals(3)
        m = false;
        while ~m
            [Y, m] = local_simulation(lam, t, ...
                [6 5 4 3], [X(1:t,3) X(1:t,4) X(1:t,5) X(1:t,6)]);
        end
        X(t,1) = Y(t,8);
        X(t,2) = Y(t,7);
    end
    if arrivals(9) || arrivals(10)
        m = false;
        while ~m
            [Z, m] = local_simulation(lam, t, ...
                [9 8 7 6], [X(1:t,6) X(1:t,7) X(1:t,8), X(1:t,9)]);
        end
        X(t,9) = Z(t,5);
        X(t,10) = Z(t,4);
    end
    
    
    X(t+1,3:9) = X(t,3:9);
    for i = 2:10
        % Entering
        if arrivals(i)
            neighbor_index = i-1:i+1;
            neighbor_lengths = X(t, neighbor_index);
            [~, j] = min(neighbor_lengths);
            min_neighbor = neighbor_index(j);
            X(t+1, min_neighbor) = X(t+1,min_neighbor) + 1;
        end
        % Exiting
        if X(t+1,i) > 0
            X(t+1,i) = X(t+1,i) - 1;
        end
    end
    
    if nargin > 3 && ~isequal(X(t+1,match_cols), match_vals(t+1,:))
        return
    end
end

match = true;

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



