%% Description
% Run ring sim is a script file where each section generates a different
% plot which is used in the week 3 report. It is meant to be run in
% sections and not all at once.

%% Initialize Params
% Number of times run ring sim. (This will take a long time!)
num_samples = 100;
% Parameters for running the ring sim.
n = 600; lam = 0.95; k = 100; t_end = 30;

% Store all final vectors of S and Queue lengths for each run
ring_S_vects = zeros(num_samples, k);
ring_Q_vects = zeros(num_samples, n);

%% Obtain Ring Topology Data
for iter = 1:num_samples
    tic;
    % run the ring sim for a random length of time ~ [20,40]
    [S, Q] = ...
        ctmc_ring_sim(n, lam, k, randi([20,40]), false, false, 2);
    toc;
    ring_S_vects(iter,:) = S;
    ring_Q_vects(iter,:) = Q;
    % Comment out to save data after each run in case computer crashes.
    %save('ring_S_vects.mat','ring_S_vects');
    %save('ring_Q_vects.mat', 'ring_Q_vects');
    %disp(iter);
end

%% Calculate the Emperical and The Typical
%num_samples=25;
empirical_metric = zeros(num_samples,k);
for i = 1:num_samples
    for j = 1:k
        empirical_metric(i,j) = sum(ring_Q_vects(i,:) >= j)/n;
    end
end

emperical_metric_means = zeros(num_samples,1);
emperical_metric_variances = zeros(num_samples,1);

for i = 1:num_samples
    emperical_metric_means(i) = sum(empirical_metric(i,:));
    emperical_metric_variances(i) =  (2*(1:k) * empirical_metric(i,:)') - emperical_metric_means(i)^2;
end


typical_metric = zeros(n,k);
for i = 1:n
    for j = 1:k
        typical_metric(i,j) = sum(ring_Q_vects(:,i) >= j)/num_samples;
    end
end

typical_metric_means = zeros(n,1);
typical_metric_variances = zeros(n,1);

for i = 1:n
    typical_metric_means(i) = sum(typical_metric(i,:));
    typical_metric_variances(i) =  (2*(1:k) * typical_metric(i,:)') - typical_metric_means(i)^2;
end

clf;
subplot(2,1,1);
bins = 2:0.05:3.2;
hold on
histogram(typical_metric_means(1:num_samples), bins);
histogram(emperical_metric_means(1:num_samples), bins);
legend('typical metric means', 'emperical metric means');
ylabel('number of metrics for which mean falls in this range');
title('100 mean of the typical and emperical metric');
subplot(2,1,2);
bins = 4:0.1:6.1;
hold on;
histogram(typical_metric_variances(1:num_samples), bins);
histogram(emperical_metric_variances(1:num_samples), bins);
legend('typical metric variances', 'emperical metric variances');
ylabel('number of metrics for which variance falls in this range');
title('100 variances of the typical and emperical metric');

%%
clf
hold on
for i = 1:num_samples
    plot(typical_metric(i,1:8),'r')
    plot(empirical_metric(i,1:8),'b')
end
legend('typical 1-cdf', 'empirical 1-cdf');

%% Generate the same Data (final values of S and Queue Lengths) for M/M/1
mm1_S_vects = zeros(num_samples, k);
mm1_Queues = zeros(num_samples, n);
for iter = 1:num_samples
    tic;
    [S, Q, ~] = ...
        ctmc_ring_sim(n, lam, k, randi([20,40]), false, true, false);
    toc;
    mm1_S_vects(iter,:) = S;
    mm1_Queues(iter,:) = Q;
end

%% Compare Ring Topology with M/M/1 and SQ(3)
l = 20;
fixed_pt = @(d) lam.^((d.^(0:(l-1)) - 1)/(d-1));
clf
hold on
ring_means = mean(ring_S_vects);
mm1_means = mean(mm1_S_vects);

% Regular Plot
subplot(1,2,1)
hold on
plot(mm1_means(1:l));
plot(ring_means(1:l));
plot(fixed_pt(3));
legend('MM1 (Emperical)', 'Ring S (Emperical)', 'SQ(3)');
xlabel('K');
ylabel('Ratio of servers with length \geq K');

% Log Plot
subplot(1,2,2)
hold on
plot(mm1_means(1:l));
plot(ring_means(1:l));
fixed_point_fixed = fixed_pt(3);
fixed_point_fixed(fixed_point_fixed < 1e-3) = 0;
plot(fixed_point_fixed);
xlabel('K');
ylabel('Ratio of servers with length \geq K');
set(gca, 'YScale', 'log')
ylim([0.005,1])




