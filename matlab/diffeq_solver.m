n = 1000;
lam = 0.95;
d1 = @(t,s) power2choices_diffeq(n,lam,1,t,s);
d2 = @(t,s) power2choices_diffeq(n,lam,2,t,s);
d3 = @(t,s) power2choices_diffeq(n,lam,3,t,s);

init_cond = zeros(n,1); init_cond(1) = 1;

t_end = 1000;
[t1,s1] = ode45(d1,[0 t_end],init_cond);
[t2,s2] = ode45(d2,[0 t_end],init_cond);
[t3,s3] = ode45(d3,[0 t_end],init_cond);

for k = 1:min([length(t1), length(t2), length(t3)])
    clf
    hold on
    plot(s1(k,1:50))
    plot(s2(k,1:50))
    plot(s3(k,1:50))
    plot([1 lam.^(2.^(1:49)-1)])
    plot([1 lam.^((3.^(1:50)-1)./2)])
    %set(gca, 'XScale', 'log')
    axis([0 30 0 1])
    pause(0.01)
    disp(k);
end

