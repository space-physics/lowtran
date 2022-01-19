function [wavelength,transmittance] = lowtran_groud2space(varargin)
% Lowtran model from Matlab. 
% Senario: a vertical or slant path from a certain altitude to space
% https://www.scivision.dev/matlab-python-user-module-import/
assert(~verLessThan('matlab', '9.5'), 'Matlab >= R2018b required')

%% Deal with input values
% Order of parameters and default values: 
%     'model', 5;
%     'altitude', 0;
%     'zenith_angle', 45;
%     'wavelength_start', 200;
%     'wavelength_end', 2000;
occupy = [0,0,0,0,0];
for i = 1:length(varargin)
    switch class(varargin{i})
        case 'char'
            if strcmp(varargin{i},'model')
                model = varargin{i+1};
                occupy(1) = 1;
            elseif strcmp(varargin{i},'altitude')
                altitude = varargin{i+1};
                occupy(2) = 1;
            elseif strcmp(varargin{i},'zenith_angle')
                zenith_angle = varargin{i+1};
                occupy(3) = 1;
            elseif strcmp(varargin{i},'wavelength_start')
                wavelength_start = varargin{i+1};
                occupy(4) = 1;
            elseif strcmp(varargin{i},'wavelength_end')
                wavelength_end = varargin{i+1};
                occupy(5) = 1;
            end
    end
end
if occupy(1) == 0
    model = 0;
end
if occupy(2) == 0
    altitude = 10;
end
if occupy(3) == 0
    zenith_angle = 45;
end
if occupy(4) == 0
    wavelength_start = 1;
end
if occupy(5) == 0
    wavelength_end = 1;
end

%% Apply lowtran code
p.model = model;
p.h1 = altitude;
p.angle = zenith_angle;
p.wlshort = wavelength_start;
p.wllong = wavelength_end;

c1 = py.dict(p);
T = py.lowtran.transmittance(c1);
transmittance = squeeze(xarray2mat(T{'transmission'}));
transmittance = transmittance.';
wavelength = xarray2mat(T{'wavelength_nm'});

end
