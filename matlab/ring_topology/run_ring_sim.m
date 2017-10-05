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
S_vects = zeros(num_samples, k);
Queues = zeros(num_samples, n);

%% Obtain Ring Topology Data
for iter = 1:num_samples
    tic;
    % run the ring sim for a random length of time ~ [20,40]
    [S, Q, ~] = ...
        ctmc_ring_sim(n, lam, k, randi([20,40]), false, false, false);
    toc;
    S_vects(iter,:) = S;
    Queues(iter,:) = Q;
    % Comment out to save data after each run in case computer crashes.
    % save('s.mat','S_vects');
    % save('q.mat', 'Queues');
    disp(iter);
end

%% Plot Emperical vs. Indicator (see week 3 report for details)
clf;
hold on;
plot(sum(Queues(:,1)>=0:10)/100)
plot(sum(Queues(:,n)>=0:10)/100)

m = mean(S_vects);
plot(m(1:10));
legend('Q_1 \geq i', 'Q_n \geq i', 'Emperical Measure'); 

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
ring_means = mean(S_vects);
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



%% Plot the maxes vector
[~, ~, maxes] = ctmc_ring_sim(n, lam, k, randi([20,40]), false, false, true);
plot(maxes);
xlabel('Queue #');
ylabel('sup_t Q_i(t)');

