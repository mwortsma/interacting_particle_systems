load('full_sim_data')
load('full_sim_data2')
load('local_sim_data')
load('local_sim_opt_data')

% Parameters
num_iterations = 100000;
t_end = 4;
n = 600;

F_local = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations
    for j = 1:t_end
        A = local_sim_data(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_local(j,num) = F_local(j,num) + 1;
    end
end
F_local = F_local / (num_iterations/t_end);

F_full = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations
    for j = 1:t_end
        A = full_sim_data(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_full(j,num) = F_full(j,num) + 1;
    end
end

F_full = F_full / (num_iterations/t_end);


F_full2 = zeros(t_end, 2^(t_end*3));

for i = 1:t_end:num_iterations
    for j = 1:t_end
        A = full_sim_data2(i:i+j-1,1:3);
        num = 1+bin2dec(num2str(reshape(A, [1 3*j])));
        F_full2(j,num) = F_full2(j,num) + 1;
    end
end

F_full2 = F_full2 / (num_iterations/t_end);


F_opt = zeros(t_end, 2^(t_end*3));

for i = 1:4
    subplot(2,2,i);
    if i == 1
        ylim([0 1])
    end
    hold on
    plot(F_local(i,1:2^(3*i)))
    plot(F_full(i,1:2^(3*i)))
    plot(F_full2(i,1:2^(3*i)))
    title(sprintf('up to time %d%', i));
    legend('local simulation', 'full system', 'full system (copy)')
    xlabel('x')
    ylabel('Probability of observing binary(x)')
end

diff0 = abs(F_full(4,:) - F_full2(4,:));
diff1 = abs(F_full(4,:) - F_local(4,:));
diff2 = abs(F_full2(4,:) - F_local(4,:));

disp('norms')
disp(norm(diff0))
disp(norm(diff1))
disp(norm(diff2))

disp('max')
disp(max(diff0))
disp(max(diff1))
disp(max(diff2))


