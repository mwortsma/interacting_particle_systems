beta = 1.1;
h = 0.5;

sub_rows = 2;
sub_cols = 3;

params = ...
    [5, 1000, 50; 
     25, 1000, 250;
     125, 1000, 1000
     5, 10000, 50; 
     25, 10000, 250;
     125, 10000, 1000];

close all; clf;
for i = 1:size(params,1)
    N = params(i,1);
    full_system_iters = params(i,2);
    tau = 1:params(i,3);

    [mu, typical_distribution] = ...
        run_full_vs_iterative(N, full_system_iters, tau, beta,h);

    subplot(sub_rows,sub_cols, i);
    hold on;
    plot(mu(:,1))
    plot(typical_distribution(:,1))
    title(sprintf(...
        "N = %d, iters = %d",N, full_system_iters));
    xlabel("time")
    ylabel("Prob[Y = -1]");
    legend('fixed pt','full system')
    disp('row');
    disp(i);
end