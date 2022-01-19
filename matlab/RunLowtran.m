clear;

%% Set parameters
% Units: distance in km, wavelength in nm, angle in degree
model = 6;   % selects the geographical - seasonal model atmosphere
             % 0: If meteorological data are specified (horizontal path only)
             % 1: Tropical Atmosphere
             % 2: Midlatitude Summer
             % 3: Midlatitude Winter
             % 4: Subarctic Summer
             % 5: Subarctic Winter
             % 6: 1976 US Standard
             % 7: If a new model atmosphere (e.g. radiosonde data) is to be read in


%% For a horizontal (constant-pressure) path
[wavelength_x, transmittance_y] = lowtran_horizaltrans(...
                     'model',model,...
                     'altitude',0,...
                     'transmission_distance',10,...
                     'wavelength_start',200,...
                     'wavelength_end',2000);
figure(1);
plot(wavelength_x, transmittance_y)
ylim([0,1])
xlabel('wavelength (nm)')
ylabel('transmittance')
title({'Horizontal transmittance at altitude 0 km'; ...
       'with transmission distance of 10 km at subarctic winter.'})

%% For a vertical or slant path from a certain altitude to space
[wavelength_x, transmittance_y] = lowtran_groud2space(...
                     'model',model,...
                     'altitude',0,...
                     'zenith_angle',45,...      % vector could work
                     'wavelength_start',200,...
                     'wavelength_end',2000);
figure(2);
plot(wavelength_x, transmittance_y)
ylim([0,1])
xlabel('wavelength (nm)')
ylabel('transmittance')
title({'Transmittance from altitude 0 km to space'; ...
       'with zenith angle 45° at subarctic winter.'})
