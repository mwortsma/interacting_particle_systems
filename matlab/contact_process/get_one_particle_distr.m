T = 4; d = 3;
f_left = zeros(1,2^T);
f_mid = zeros(1,2^T);
f_right = zeros(1,2^T);
for index = 1:2^(d*T)
    prob = mu(index);
    if prob > 0
        mat = index_to_mat(index,T,d);
        
        path = mat(:,1);
        path_index = mat_to_index(path,T,1);
        f_left(path_index) = f_left(path_index) + prob;
        
        path = mat(:,2);
        path_index = mat_to_index(path,T,1);
        f_mid(path_index) = f_mid(path_index) + prob;
        
        path = mat(:,3);
        path_index = mat_to_index(path,T,1);
        f_right(path_index) = f_right(path_index) + prob;
    end
end

load('full_sim_data');
f_left_full = zeros(1,2^T);
f_mid_full = zeros(1,2^T);
f_right_full = zeros(1,2^T);
for index = 1:2^(d*T)
    prob = F_full_scaled(4,index);
    if prob > 0
        mat = index_to_mat(index,T,d);
        
        path = mat(:,1);
        path_index = mat_to_index(path,T,1);
        f_left_full(path_index) = f_left_full(path_index) + prob;
        
        path = mat(:,2);
        path_index = mat_to_index(path,T,1);
        f_mid_full(path_index) = f_mid_full(path_index) + prob;
        
        path = mat(:,3);
        path_index = mat_to_index(path,T,1);
        f_right_full(path_index) = f_right_full(path_index) + prob;
    end
end



close;
hold on;
plot(f_left);
plot(f_left_full);
plot(f_mid);
plot(f_mid_full);
plot(f_right);
plot(f_right_full);
legend('left (fp)', 'left (full)', 'mid (fp)', 'mid(full)', 'right (fp)', 'right (full)');
xlabel('Binary paths of length 4');
ylabel('Probability');



f_mid_indep = zeros(1,2^T);

for index = 1:2^(d*T)
    prob = F_indep_scaled(4,index);
    if prob > 0
        mat = index_to_mat(index,T,d);
        
        path = mat(:,2);
        path_index = mat_to_index(path,T,1);
        f_mid_indep(path_index) = f_mid_indep(path_index) + prob;

    end
end