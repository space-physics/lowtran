function lowtran()
%% Lowtran model from Matlab.
% https://www.scivision.co/matlab-python-user-module-import/
assert(~verLessThan('matlab', '9.5'), 'Matlab >= R2018b required')

alt_km = 0;
zenithangle = [0, 60, 80];

c1 = py.dict(pyargs('model',5,'h1',alt_km,'angle',zenithangle,...
                    'wlshort',200,'wllong',30000));

L = py.lowtran.transmittance(c1);

trans = squeeze(xarray2mat(L{'transmission'}));
wl_nm = xarray2mat(L{'wavelength_nm'});

semilogy(wl_nm, trans(:,1))
ylim([1e-4,1])
xlabel('wavelength (nm)')
ylabel('transmittance')

end


function M = xarray2mat(V)
M = double(py.numpy.asfortranarray(V));
end
