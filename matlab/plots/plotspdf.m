load('/Users/mitchellw/Documents/Thesis/code/matlab/ring_topology/q.mat')
load('/Users/mitchellw/Documents/Thesis/code/matlab/complete_graph/cplt_Q_vects.mat')
load('/Users/mitchellw/Documents/Thesis/code/matlab/complete_graph/mm1_Q_vects.mat')
k = 100;
j1 = 50;
j2 = 50;
typical_cplt_s = zeros(k, 1);
for i = 1:length(typical_cplt_s)+1
    typical_cplt_s(i) = sum(cplt_Q_vects(:,j1) == i-1)/length(cplt_Q_vects(:,1));
end
typical_ring_s = zeros(k, 1);
for i = 1:length(typical_ring_s)+1
    typical_ring_s(i) = sum(ring_Q_vects(:,j1) == i-1)/length(ring_Q_vects(:,1));
end
typical_mm1_s = zeros(k, 1);
for i = 1:length(typical_ring_s)+1
    typical_mm1_s(i) = sum(mm1_Q_vects(:,j1) == i-1)/length(mm1_Q_vects(:,1));
end

empirical_cplt_s = zeros(k, 1);
for i = 1:length(typical_cplt_s)+1
    empirical_cplt_s(i) = sum(cplt_Q_vects(j2,:) == i-1)/length(cplt_Q_vects(1,:));
end
empirical_ring_s = zeros(k, 1);
for i = 1:length(typical_ring_s)+1
    empirical_ring_s(i) = sum(ring_Q_vects(j2,:) == i-1)/length(ring_Q_vects(1,:));
end
empirical_mm1_s = zeros(k, 1);
for i = 1:length(typical_mm1_s)+1
    empirical_mm1_s(i) = sum(mm1_Q_vects(j2,:) == i-1)/length(mm1_Q_vects(1,:));
end



x_len = 10;
clf
hold on
plot(0:x_len, typical_cplt_s(1:x_len+1))
plot(0:x_len, typical_ring_s(1:x_len+1))
plot(0:x_len, typical_mm1_s(1:x_len+1))
plot(0:x_len, empirical_cplt_s(1:x_len+1))
plot(0:x_len, empirical_ring_s(1:x_len+1))
plot(0:x_len, empirical_mm1_s(1:x_len+1))


legend('complete typical (d=3)', 'ring typical', 'mm1 typical', 'complete empirical (d=3)', 'ring empirical', 'mm1 empirical', 'fixed pt complete d=3', 'mean typical complete', 'mean empirical complete', 'mean typical ring', 'mean empirical ring')
title('normal plot')

