h = 0.5;
b = 1.5;
t_end = 100; 
N = 10;

m = @(x) (1/N)*sum(x);
H = @(x) -N*((1/2)*m(x)^2 + h*m(x));

sum_ = 0;

iter_num = 1000;
for iter = 1:iter_num
    X = zeros(t_end, N);
    X(1,:) = -2*(rand(1,N) > 0.5) + 1;

    for t = 1:t_end - 1
        i = randi(N);
        state1 = X(t,:);
        state2 = X(t,:);
        state2(i) = state2(i)*(-1);

        v = max(H(state2) - H(state1), 0);
        if rand < exp(-b*v)
            X(t+1,:) = state2;
        else
            X(t+1,:) = state1;
        end
    end
    M = zeros(t_end,1);
    for i = 1:t_end; M(i) = m(X(i,:)); end
    
    if X(end,1) == -1
        sum_ = sum_ + 1;
    end
end
disp(sum_/iter_num);

