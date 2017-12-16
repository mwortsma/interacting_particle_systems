function mat = index_to_mat(i,len, d)
    mat = zeros([1 d*len]);
    str = dec2bin(i-1);
    j = 1;
    for i = (d*len-length(str)+1):d*len
        mat(i) = str2double(str(j)); j = j + 1;
    end
    mat = reshape(mat,[len, d]);
end