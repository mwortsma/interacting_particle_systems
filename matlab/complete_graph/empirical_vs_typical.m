%% Description
% Emperical vs. Typical for the complete graph.

%% Initialize Params
% Number of times run ring sim. (This will take a long time!)
num_samples = 100;
% Parameters for running the ring sim.
n = 600; lam = 0.95; d = 3; k = 100; t_end = 50;

% Store all final vectors of S and Queue lengths for each run
cplt_S_vects = zeros(num_samples, k);
cplt_Q_vects = zeros(num_samples, n);

fixed_pt = @(d) lam.^((d.^(0:k-1) - 1)/(d-1));

%% Obtain Ring Topology Data
for iter = 1:num_samples
    tic;
    % run the ring sim for a random length of time ~ [20,40]
    [S, Q] = ...
        ctmc_simulation(n,d,lam, t_end, false);
    toc;
    cplt_S_vects(iter,:) = S;
    cplt_Q_vects(iter,:) = Q;
    % Comment out to save data after each run in case computer crashes.
    save('cplt_S_vects.mat','cplt_S_vects');
    save('cplt_Q_vects.mat', 'cplt_Q_vects');
    
    clf
    hold on
    plot(S(1:20));
    fp = fixed_pt(d);
    plot(fp(1:20));
    legend('sim', 'fixed pt');
            
    disp(iter);
end

%% Calculate the Emperical and The Typical

load('cplt_Q_vects.mat')

empirical_metric = zeros(num_samples,k);
for i = 1:num_samples
    for j = 1:k
        empirical_metric(i,j) = sum(cplt_Q_vects(i,:) >= j)/n;
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
        typical_metric(i,j) = sum(cplt_Q_vects(:,i) >= j)/num_samples;
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
bins = 2:0.05:3;
hold on
histogram(typical_metric_means(1:100), bins);
histogram(emperical_metric_means(1:100), bins);
legend('typical metric means', 'emperical metric means');
ylabel('number of metrics for which mean falls in this range');
title('100 mean of the typical and emperical metric');
subplot(2,1,2);
bins = 3:0.05:4;
hold on;
histogram(typical_metric_variances(1:100), bins);
histogram(emperical_metric_variances(1:100), bins);
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
