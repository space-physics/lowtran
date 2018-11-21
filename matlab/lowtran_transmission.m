function T = lowtran_transmission(params)
%% Lowtran model from Matlab.
% https://www.scivision.co/matlab-python-user-module-import/
assert(~verLessThan('matlab', '9.5'), 'Matlab >= R2018b required')

validateattributes(params, {'struct'}, {'scalar'})

c1 = py.dict(params);

T = py.lowtran.transmittance(c1);

end
