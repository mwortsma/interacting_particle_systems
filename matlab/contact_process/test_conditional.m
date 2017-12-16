mat1 = [1 1 0; 1 1 1; 0 0 1];
mat2 = [1 1 0; 1 1 0; 0 0 1];

f = zeros(1,2^(3*3));
f(mat_to_index(mat1,3,3)) = 1/2;
f(mat_to_index(mat2,3,3)) = 1/2;

[l r] = get_conditional_distributions(f,3);

test_mat = mat_to_index([1 1; 1 1], 2,2);
test_mat_2 = mat_to_index([1 0; 1 0; 0 1], 3, 2);
test_mat_3 = mat_to_index([1 0; 1 0], 2, 2);
disp(r(2,test_mat))
disp(l(3,test_mat_2))
disp(l(2,test_mat_2))