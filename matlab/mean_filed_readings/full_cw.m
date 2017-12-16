function typical_distribution = full_cw(N,t_end,h,beta,j,iters, ~)
    typical_distribution = zeros(t_end,2);
    for iter = 1:iters
        if nargin > 6
            X = one_iter_full_cw(N, t_end, h, beta, j,0);
        else
            X = one_iter_full_cw(N, t_end, h, beta, j);
        end
           
        typical_distribution = typical_distribution + X/iters;
    end
end

function realization = one_iter_full_cw(N, t_end, h, beta, j, ~)

    m = @(x) (1/N)*sum(x);
    H = @(x) -N*((1/2)*m(x)^2 + h*m(x));

    X = zeros(t_end, N);
    X(1,:) = -2*(rand(1,N) > 0.5) + 1;

    for t = 1:t_end - 1
        i = randi(N);
        state1 = X(t,:);
        state2 = X(t,:);
        state2(i) = state2(i)*(-1);

        v = max(H(state2) - H(state1), 0);
        if rand < exp(-beta*v)
            X(t+1,:) = state2;
        else
            X(t+1,:) = state1;
        end
    end
    
    realization = [X(:,j) == -1, X(:,j) == 1];
    
    if nargin > 5
        suptitle(sprintf(...
            'Currie-Weiss with beta = %0.1f, h = %0.1f', beta, h));
        subplot(1,2,1);
        imagesc(X);
        xlabel('particle')
        ylabel('time')
        subplot(1,2,2);
        plot(sum(X == -1,2)/N);
        xlabel('time')
        ylabel('Empirical Pr[Y = -1]')
    end
end


