function T = transmission(params)
%% Lowtran model from Matlab.
% https://www.scivision.dev/matlab-python-user-module-import/
arguments
  params (1,1) struct
end

c1 = py.dict(params);

T = py.lowtran.transmittance(c1);

end
