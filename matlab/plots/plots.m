load('/Users/mitchellw/Documents/Thesis/code/matlab/ring_topology/ring_Q_vects.mat')
load('/Users/mitchellw/Documents/Thesis/code/matlab/complete_graph/cplt_Q_vects.mat')
load('/Users/mitchellw/Documents/Thesis/code/matlab/complete_graph/mm1_Q_vects.mat')
k = 100;
j1 = 50;
j2 = 50;
typical_cplt_s = zeros(k, 1);
for i = 1:length(typical_cplt_s)
    typical_cplt_s(i) = sum(cplt_Q_vects(:,j1) >= i)/length(cplt_Q_vects(:,1));
end
typical_ring_s = zeros(k, 1);
for i = 1:length(typical_ring_s)
    typical_ring_s(i) = sum(ring_Q_vects(:,j1) >= i)/length(ring_Q_vects(:,1));
end
typical_mm1_s = zeros(k, 1);
for i = 1:length(typical_ring_s)
    typical_mm1_s(i) = sum(mm1_Q_vects(:,j1) >= i)/length(mm1_Q_vects(:,1));
end

empirical_cplt_s = zeros(k, 1);
for i = 1:length(typical_cplt_s)
    empirical_cplt_s(i) = sum(cplt_Q_vects(j2,:) >= i)/length(cplt_Q_vects(1,:));
end
empirical_ring_s = zeros(k, 1);
for i = 1:length(typical_ring_s)
    empirical_ring_s(i) = sum(ring_Q_vects(j2,:) >= i)/length(ring_Q_vects(1,:));
end
empirical_mm1_s = zeros(k, 1);
for i = 1:length(typical_mm1_s)
    empirical_mm1_s(i) = sum(mm1_Q_vects(j2,:) >= i)/length(mm1_Q_vects(1,:));
end



x_len = 10;
clf

subplot(3,1,1)
hold on
plot(0:x_len, [1; typical_cplt_s(1:x_len)])
plot(0:x_len, [1; typical_ring_s(1:x_len)])
plot(0:20, [1; typical_mm1_s(1:20)])
plot(0:x_len, [1; empirical_cplt_s(1:x_len)])
plot(0:x_len, [1; empirical_ring_s(1:x_len)])
plot(0:20, [1; empirical_mm1_s(1:20)])
plot(0:x_len, [1 0.95.^( (3.^(1:x_len) - 1)/2 )]);

mean_typical_cplt = sum(typical_cplt_s);
plot([mean_typical_cplt mean_typical_cplt], [0 1])
mean_empirical_cplt = sum(empirical_cplt_s);
plot([mean_empirical_cplt mean_empirical_cplt], [0 1])

mean_typical_ring = sum(typical_ring_s);
plot([mean_typical_ring mean_typical_ring], [0 1])
mean_empirical_ring = sum(empirical_ring_s);
plot([mean_empirical_ring mean_empirical_ring], [0 1])

legend('complete typical (d=3)', 'ring typical', 'mm1 typical', 'complete empirical (d=3)', 'ring empirical', 'mm1 empirical', 'fixed pt complete d=3', 'mean typical complete', 'mean empirical complete', 'mean typical ring', 'mean empirical ring')
title('normal plot')

subplot(3,1,2)
hold on
plot(0:x_len, log([1; typical_cplt_s(1:x_len)]))
plot(0:x_len, log([1; typical_ring_s(1:x_len)]))
plot(0:7, log([1; typical_mm1_s(1:7)]))
plot(0:x_len, log([1; empirical_cplt_s(1:x_len)]))
plot(0:x_len, log([1; empirical_ring_s(1:x_len)]))
plot(0:7, log([1; empirical_mm1_s(1:7)]))
plot(0:6, log(0.95)*(3.^(0:6) - 1)/2)
legend('complete typical (d=3)', 'ring typical', 'mm1 typical', 'complete empirical (d=3)', 'ring empirical', 'mm1 empirical', 'fixed pt complete d=3', 'Location', 'southwest')
title('log plot')

subplot(3,1,3)
hold on
plot(0:x_len,real(log(log([1; typical_cplt_s(1:x_len)]))));
plot(0:x_len,real(log(log([1; typical_ring_s(1:x_len)]))));
plot(0:7,real(log(log([1; typical_mm1_s(1:7)]))));
plot(0:x_len,real(log(log([1; empirical_cplt_s(1:x_len)]))));
plot(0:x_len,real(log(log([1; empirical_ring_s(1:x_len)]))));
plot(0:7,real(log(log([1; empirical_mm1_s(1:7)]))));
plot(0:6, real(log(log(0.95)) - log(2) + log((3.^(0:6)) - 1)));
legend('complete typical (d=3)', 'ring typical', 'mm1 typical', 'complete empirical (d=3)', 'ring empirical', 'mm1 empirical', 'fixed pt complete d=3', 'Location', 'northwest')
title('log-log plot');