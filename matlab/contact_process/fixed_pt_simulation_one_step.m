function [f_new,l_new,r_new] = fixed_pt_simulation_one_step(f, T, nu, iters,p,q,l,r)
    f_new = zeros(1, 2^(3*T));
    
    % Do this empirically.
    inc = 1/iters;
    
    left_totals = zeros(T,2^(2*T));
    right_totals = zeros(T,2^(2*T));
    left_counts = zeros(T,2^(2*T));
    right_counts = zeros(T,2^(2*T));
    
    for iter = 1:iters
        
        X = evolve_system(l,r,nu,T,p,q);
        index = mat_to_index(X,T,3);
        f_new(index) = f_new(index) + inc;
        
        for t = 1:T
            left_mat = X(1:t,1:2); 
            left_index = mat_to_index(left_mat,t,2);
            right_totals(t,left_index) = right_totals(t,left_index) + 1;
            right_counts(t,left_index) = right_counts(t,left_index) + ...
                (X(t,3) == 0);
            
            right_mat = X(1:t,2:3); 
            right_index = mat_to_index(right_mat,t,2);
            left_totals(t,right_index) = left_totals(t,right_index) + 1;
            left_counts(t,right_index) = left_counts(t,right_index) + ...
                (X(t,1) == 0);
        end
    end
    l_new = left_counts ./ left_totals;
    r_new = right_counts ./ right_totals;
end