
alt_km = 0;
zenithangle = [0, 60, 80];

p.model=5;
p.h1=alt_km;
p.angle=zenithangle;
p.wlshort= 200;
p.wllong=30000;

T = lowtran.transmission(p);

lowtran.plot_transmission(T)
