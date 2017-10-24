n_vect = 10000:10000:200000;
iters = length(n_vect);
cplt_data = zeros(iters,1);
mm1_data = zeros(iters,1);
ring_data = zeros(iters,1);
lnln_data = zeros(iters,1);
ln_data = zeros(iters,1);


for iter = 1:iters
    n = n_vect(iter);
    m = 200000;
    
    mm1_bins = zeros(n,1);
    cplt_bins = zeros(n, 1);
    ring_bins = zeros(n,1);

    for i = 1:m
        ids = randi(n,2,1);
        [~, a] = min(cplt_bins(ids));
        cplt_bins(ids(a),1) = cplt_bins(ids(a),1) + 1;
        
        mm1_id = randi(n,1,1);
        mm1_bins(mm1_id) = mm1_bins(mm1_id) + 1;
        
        ring_id = randi(n,1,1);
        ring_ids = 1 + mod(ring_id-2:ring_id,n);
        [~, a] = min(ring_bins(ring_ids));
        ring_bins(ring_ids(a),1) = ring_bins(ring_ids(a),1) + 1;
    end
    
    cplt_data(iter) = max(cplt_bins);
    mm1_data(iter) = max(mm1_bins);
    ring_data(iter) = max(ring_bins);
    lnln_data(iter) = ( log(log(n))/log(2) + (m/n));
    ln_data(iter) = m/n + sqrt(m*log(n)/n);
end

hold on
plot(cplt_data)
plot(mm1_data)
plot(ring_data)
plot(lnln_data)
plot(ln_data)
legend('cplt', 'mm1', 'ring', 'lnln', 'ln');