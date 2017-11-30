function out = generate_sample(t_end,p,q,match_cols,match_vals, x, t, alg)
    if alg == 1
        out = generate_sample_1(t_end,p,q,match_cols,match_vals, x, t, alg);
    end
end

function out = generate_sample_1(t_end,p,q,match_cols,match_vals, x)
    while 1
        [Z, match] = local_approx_simulation(t_end,p,q,match_cols,match_vals);
        if match
            break
        end
    end
    out = Z(t_end,x);
end