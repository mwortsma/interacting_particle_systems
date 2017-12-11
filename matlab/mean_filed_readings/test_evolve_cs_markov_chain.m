
N = 10;
tau = 1:100;

f_original = zeros(length(tau), 2)*(1/2);
f_original(:,1) = rand(length(tau),1);
f_original(:,2) = 1 - f_original(:,1);
nu = f_original(1,:);

beta = 1.5;
h = 0.5;

iters = 10;
r = zeros(1,length(iters));
f = f_original;
for i = 1:iters
    f_new = evolve_cw_markov_chain(tau, nu, f, N, beta, h);
    r(i) = norm(f_new - f);
    f = f_new;
end
