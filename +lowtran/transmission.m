function T = transmission(model, alt_km, zenith_angle, wavelen_minmax)
%% Horizontal transmission
% https://www.scivision.dev/matlab-python-user-module-import/
arguments
  model (1,1) {mustBeNonnegative,mustBeInteger}
  alt_km (1,1) {mustBeNonnegative, mustBeReal} = 0
  zenith_angle (1,:) {mustBeNonnegative, mustBeReal} = 0
  wavelen_minmax (1,2) {mustBeNonnegative, mustBeReal} = [200, 30000]
end

p = struct(model=model, h1=alt_km, angle=zenith_angle, ...
    wlshort=wavelen_minmax(1), wllong=wavelen_minmax(2));

T = py.lowtran.transmittance(py.dict(p));

end
