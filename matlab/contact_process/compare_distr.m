load('full_sim_data')
load('full_sim_data2')
load('local_sim_data')
load('local_sim_independent_data')

%local_sim_data = local_sim_opt_data;

% Parameters
num_iterations = 10000;
t_end = 4;

F_local = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations*t_end
    for j = 1:t_end
        A = local_sim_data(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_local(j,num) = F_local(j,num) + 1;
    end
end
F_local_scaled = F_local / (num_iterations);

F_full = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations*t_end
    for j = 1:t_end
        A = full_sim_data(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_full(j,num) = F_full(j,num) + 1;
    end
end

F_full_scaled = F_full / (num_iterations);


F_full2 = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations*t_end
    for j = 1:t_end
        A = full_sim_data2(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_full2(j,num) = F_full2(j,num) + 1;
    end
end

F_full2_scaled = F_full2 / (num_iterations);


F_indep = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations*t_end
    for j = 1:t_end
        A = local_sim_independent_data(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_indep(j,num) = F_indep(j,num) + 1;
    end
end

F_indep_scaled = F_indep / (num_iterations);


for i = 1:4
    subplot(2,2,i);
    if i == 1
        ylim([0 1])
    end
    hold on
    plot(F_local_scaled(i,1:2^(3*i)))
    plot(F_full_scaled(i,1:2^(3*i)))
    plot(F_full2_scaled(i,1:2^(3*i)))
    plot(F_indep_scaled(i,1:2^(3*i)))
    title(sprintf('up to time %d%', i));
    legend('local simulation', 'full system', 'full system (copy)', 'independent version')
    xlabel('x')
    ylabel('Probability of observing binary(x)')
end

diff0 = abs(F_full_scaled(4,:) - F_full2_scaled(4,:));
diff1 = abs(F_full_scaled(4,:) - F_local_scaled(4,:));
diff2 = abs(F_full_scaled(4,:) - F_indep_scaled(4,:));

%diff3 = abs(F_full(4,:) - F_opt(4,:));
%diff4 = abs(F_full2(4,:) - F_opt(4,:));
%diff5 = abs(F_opt(4,:) - F_local(4,:));


disp('norms')
disp(norm(diff0))
disp(norm(diff1))
disp(norm(diff2))
%disp(norm(diff3))
%disp(norm(diff4))
%disp(norm(diff5))

disp('max')
disp(max(diff0))
disp(max(diff1))
disp(max(diff2))

%% Chi square tests
chi2_full_full2 = 0;
non_empty = 0;
for i = 1:2^(t_end*3)
    Si = F_full(4,i);
    Ri = F_full2(4,i);
    if Si + Ri == 0; continue; end
    chi2_full_full2 = chi2_full_full2 + ((Ri - Si)^2/(Ri + Si));
    non_empty = non_empty + 1;
end
disp('p value full/full case')
p_full_full2 = 1-chi2cdf(chi2_full_full2,non_empty-1);
disp(p_full_full2);

chi2_full_local = 0;
non_empty = 0;
for i = 1:2^(t_end*3)
    Si = F_full2(4,i);
    Ri = F_local(4,i);
    if Si + Ri == 0; continue; end
    chi2_full_local = chi2_full_local + ((Ri - Si)^2/(Ri + Si));
    non_empty = non_empty + 1;
end
disp('p value full/local case')
p_full_local = 1-chi2cdf(chi2_full_local,non_empty-1);
disp(p_full_local);

chi2_full_indep = 0;
non_empty = 0;
for i = 1:2^(t_end*3)
    Si = F_full(4,i);
    Ri = F_indep(4,i);
    if Si + Ri == 0; continue; end
    chi2_full_indep = chi2_full_indep + ((Ri - Si)^2/(Ri + Si));
    non_empty = non_empty + 1;
end
disp('p value full/independent case')
p_full_indep = 1-chi2cdf(chi2_full_indep,non_empty-1);
disp(p_full_indep);

% tv distance
disp('Total Variation Distance');
disp((1/2)*sum(abs(F_full_scaled(4,:) - F_full2_scaled(4,:))))
disp((1/2)*sum(abs(F_full_scaled(4,:) - F_local_scaled(4,:))))
disp((1/2)*sum(abs(F_full_scaled(4,:) - F_indep_scaled(4,:))))