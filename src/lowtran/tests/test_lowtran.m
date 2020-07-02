%% environment
assert(~verLessThan('matlab', '9.5'), 'Matlab >= R2018b required')

%% simple
cwd = fileparts(mfilename('fullpath'));
addpath(fullfile(cwd,'../../../matlab'))

alt_km = 0;
zenithangle = [0, 60, 80];

p.model=5;
p.h1=alt_km;
p.angle=zenithangle;
p.wlshort= 200;
p.wllong=30000;

T = lowtran_transmission(p);

trans = double(T{'transmission'}.values);

assert(abs(trans(32) - 0.9468) < 1e-4, 'transmission error excessive')
