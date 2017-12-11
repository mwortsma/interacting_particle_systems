load('full_sim_data')
load('full_sim_data2')
load('local_sim_data')
load('local_sim_independent_data')

% up to 2500
num_iterations = 25000;
t_end = 4;
j = 4;

local_data = zeros(1, num_iterations);
full_data = zeros(1, num_iterations);
full2_data = zeros(1, num_iterations);
independent_data = zeros(1, num_iterations);

k = 0;
for i = 1:t_end:t_end*num_iterations
    k = k + 1;
    A = local_sim_data(i:i+j-1,1:3);
    local_data(k) = 1+bin2dec(num2str(reshape(A, [1 3*j])));
    
    A = full_sim_data(i:i+j-1,1:3);
    full_data(k) = 1+bin2dec(num2str(reshape(A, [1 3*j])));
    
    A = local_sim_independent_data(i:i+j-1,1:3);
    independent_data(k) = 1+bin2dec(num2str(reshape(A, [1 3*j])));
    
end

[~,chi2_full_local,p_full_local] = crosstab(full_data,local_data);
disp(p_full_local);
[~,chi2_full_indep,p_full_indep] = crosstab(full_data,independent_data);
disp(p_full_indep);

clf;
hold on;

[counts1, binCenters1] = hist(full_data, 500);
[counts2, binCenters2] = hist(full2_data, 500);
[counts3, binCenters3] = hist(local_data, 500);
[counts4, binCenters4] = hist(independent_data, 500);
plot(binCenters1, counts1, 'r-');
hold on;
plot(binCenters2, counts2, 'g-');
plot(binCenters3, counts3, 'k-');
plot(binCenters4, counts4, 'b-');

%h1 = hist(full2_data,100, 'facecolor','r','facealpha',.5,'edgecolor','none');
%h2 = hist(full_data,100, 'facecolor','b','facealpha',.5,'edgecolor','none'));
