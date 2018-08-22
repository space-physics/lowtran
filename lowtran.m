function igrf12()
% quick demo calling Lowtran model from Matlab.
% https://www.scivision.co/matlab-python-user-module-import/

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


function V = xarray2mat(V)
  % convert xarray 2-D array to Matlab matrix


V = V.values;
S = V.shape;
V = cell2mat(cell(V.ravel('F').tolist()));

switch length(S)
  case 2, V = reshape(V,[int64(S{1}), int64(S{2})]);
  case 3, V = reshape(V,[int64(S{1}), int64(S{2}), int64(S{3})]);
end

end

function I = xarrayind2vector(V,key)

C = cell(V{1}.indexes{key}.values.tolist);  % might be numeric or cell array of strings

if iscellstr(C) || any(class(C{1})=='py.str')
    I=cellfun(@char,C, 'uniformoutput',false);
else
    I = cell2mat();
end % if

end % function
