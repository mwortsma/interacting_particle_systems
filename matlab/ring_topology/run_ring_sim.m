%% Get Data
num_S_vects = 100;

n = 600; lam = 0.95; k = 100; t_end = 30;

S_vects = zeros(num_S_vects, k);
Queues = zeros(num_S_vects, n);

for iter = 1:num_S_vects
    tic;
    [S, Q, ~] = ctmc_ring_sim(n, lam, k, randi([20,40]), false, false, false);
    toc;
    S_vects(iter,:) = S;
    Queues(iter,:) = Q;
    save('s.mat','S_vects');
    save('q.mat', 'Queues');
    disp(iter);
end

%% Plot Emperical vs. Indicator
clf;
hold on;
plot(sum(Queues(:,1)>=0:10)/100)
plot(sum(Queues(:,n)>=0:10)/100)

m = mean(S_vects);
plot(m(1:10));
legend('Q_1 \geq i', 'Q_n \geq i', 'Emperical Measure'); 

%% Get M/M/1 Data
mm1_S_vects = zeros(num_S_vects, k);
mm1_Queues = zeros(num_S_vects, n);
for iter = 1:num_S_vects
    tic;
    [S, Q, ~] = ctmc_ring_sim(n, lam, k, randi([20,40]), false, true, false);
    toc;
    mm1_S_vects(iter,:) = S;
    mm1_Queues(iter,:) = Q;
end

%% Compare with M/M/1 and SQ(3)

fixed_pt = @(d) lam.^((d.^(0:9) - 1)/(d-1));

clf
hold on
ring_means = mean(S_vects);
mm1_means = mean(mm1_S_vects);
plot(mm1_means(1:10));
plot(ring_means(1:10));
plot(fixed_pt(3));
legend('MM1 (Emperical)', 'Ring S (Emperical)', 'SQ(3)');
xlabel('N');
ylabel('Ratio of servers with length \geq N');

%% Get Maxes
[~, ~, maxes] = ctmc_ring_sim(n, lam, k, randi([20,40]), false, false, true);
plot(maxes);
xlabel('Queue #');
ylabel('sup_t Q_i(t)');

