function [l, r] = get_conditional_distributions(f, T)
    l = zeros(T,2^(2*T)); r = zeros(T,2^(2*T));
    for t = 1:T

        for i = 1:2^(2*t)
            two_by_T_mat = index_to_mat(i,t,2);
            
            l_data = [0 0]; r_data = [0 0];

            for j = 1:1:2^(3*T)
                full_mat = index_to_mat(j,T,3);

                if isequal(full_mat(1:t,1:2),two_by_T_mat)
                    r_data(1) = r_data(1) + f(j);
                    if full_mat(t,3) == 0
                        r_data(2) = r_data(2) + f(j);
                    end
                end

                if isequal(full_mat(1:t,2:3),two_by_T_mat)
                    l_data(1) = l_data(1) + f(j);
                    if full_mat(t,1) == 0
                        l_data(2) = l_data(2) + f(j);
                    end
                end
            end
            
            if l_data(1) > 0; l(t,i) = l_data(2)/l_data(1); else; l(t,i) = -1; end;
            if r_data(1) > 0; r(t,i) = r_data(2)/r_data(1); else; r(t,i) = -1; end;

        end
    end
end