m = 10000000;
n = 1000000;
bins = zeros(n, 1);
d = 2;
for i = 1:m
    ids = randi(n,3,1);
    [~, a] = min(bins(ids));
    bins(ids(a)) = bins(ids(a)) + 1;
end
disp(max(bins));
disp( log(log(n))/log(d) + (m/n));