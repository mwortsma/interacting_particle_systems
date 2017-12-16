function index = mat_to_index(mat,len,d)
    index = 1+bin2dec(num2str(reshape(mat, [1 d*len])));
end