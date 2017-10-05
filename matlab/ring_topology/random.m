n = 6;
z = zeros(n,n);
iter = 1000000
for k = 1:iter
    i = randi(n);
    j = randi(n);
    row = max(i,j);
    col = min(i,j);
    z(row,col) = z(row,col) + 1;
end
z = z/iter
