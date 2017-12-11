h = 0.5;
b = 1.5;
t_end = 100; 
N = 10;

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
    if rand < exp(-b*v)
        X(t+1,:) = state2;
    else
        X(t+1,:) = state1;
    end
end
M = zeros(t_end,1);
for i = 1:t_end; M(i) = m(X(i,:)); end

%suptitle(sprintf('Currie-Weiss Process with beta = %0.1f, h = %0.1f', b, h));
%subplot(1,2,1);
%imagesc(X);
%xlabel('particle')
%ylabel('time')
%subplot(1,2,2);
%plot(M);
%xlabel('time')
%ylabel('sum(states)/n')
