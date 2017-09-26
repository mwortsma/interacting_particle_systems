function dsdt = power2choices_diffeq(n, lam, d, t, s)
dsdt = zeros(n,1);
dsdt(1) = 0;
for i = 2:(n-1)
    dsdt(i) = lam*(s(i-1)^d - s(i)^d) - (s(i) - s(i+1));
end
dsdt(n) = 0;
end
