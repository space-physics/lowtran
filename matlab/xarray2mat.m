function M = xarray2mat(V)
M = double(py.numpy.asfortranarray(V));
end
