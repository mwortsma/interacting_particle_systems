load('/Users/mitchellw/Documents/Thesis/code/matlab/ring_topology/q.mat')
load('/Users/mitchellw/Documents/Thesis/code/matlab/complete_graph/cplt_Q_vects.mat')
load('/Users/mitchellw/Documents/Thesis/code/matlab/complete_graph/mm1_Q_vects.mat')

k = 100;
n = 600;
bins = 20;
empirical_cplt_means = zeros(k,1);
empirical_ring_means = zeros(k,1);
empirical_mm1_means = zeros(k,1);

typical_cplt_means = zeros(k,1);
typical_ring_means = zeros(k,1);
typical_mm1_means = zeros(k,1);

clf
hold on

for i = 1:k
    empirical_cplt_means(i) = sum(cplt_Q_vects(i,:))/n;
end
pd = fitdist(empirical_cplt_means,'Kernel','Kernel','epanechnikov');
x_values = 1:0.01:10;
y = pdf(pd,x_values);
sum(y)
plot(x_values,y)

for i = 1:k
    empirical_ring_means(i) = sum(ring_Q_vects(i,:))/n;
end
pd = fitdist(empirical_ring_means,'Kernel','Kernel','epanechnikov');
x_values = 1:0.01:10;
y = pdf(pd,x_values);
plot(x_values,y)

for i = 1:k
    empirical_mm1_means(i) = sum(mm1_Q_vects(i,:))/n;
end
pd = fitdist(empirical_mm1_means,'Kernel','Kernel','epanechnikov');
x_values = 1:0.01:10;
y = pdf(pd,x_values);
plot(x_values,y)


for i = 1:k
    typical_cplt_means(i) = sum(cplt_Q_vects(:,i))/k;
end
pd = fitdist(typical_cplt_means,'Kernel','Kernel','epanechnikov');
x_values = 1:0.01:10;
y = pdf(pd,x_values);
sum(y)
plot(x_values,y)

for i = 1:k
    typical_ring_means(i) = sum(ring_Q_vects(:,i))/k;
end
pd = fitdist(typical_ring_means,'Kernel','Kernel','epanechnikov');
x_values = 1:0.01:10;
y = pdf(pd,x_values);
plot(x_values,y)



for i = 1:k
    typical_mm1_means(i) = sum(mm1_Q_vects(:,i))/k;
end
pd = fitdist(typical_mm1_means,'Kernel','Kernel','epanechnikov');
x_values = 1:0.01:10;
y = pdf(pd,x_values);
plot(x_values,y)


legend('empirical complete', 'empirical ring', 'empirical mm1', 'typical complete', 'typical ring', 'typical mm1')


title('distributions of means, 100 samples with n = 600 queues')