
[mu, res] = fixed_point_simulation(3,1/3,1/3);
plot(mu)
hold on
plot(F_full_scaled(3,1:2^9));

title('T = 3; fixed point convergence to full')
ylabel('Probability')
xlabel('space of 3 by 3 binary matricies')
legend('fixed pt simulation', 'full system')
print -dpng init_fixed_pt_results

