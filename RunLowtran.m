
alt_km = 0;
zenith_angle = [0, 60, 80];

model=5;
wavelen_minmax=[200, 30000];

T = lowtran.transmission(model, alt_km, zenith_angle, wavelen_minmax);

lowtran.plot_transmission(T)
