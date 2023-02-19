function plot_transmission(T)

trans = squeeze(xarray2mat(T{'transmission'}));
wl_nm = xarray2mat(T{'wavelength_nm'});

f = figure();
ax = gca();
semilogy(ax, wl_nm, trans(:,1))
ylim(ax, [1e-4,1])
xlabel(ax, 'wavelength (nm)')
ylabel(ax, 'transmittance')
title(ax, "Lowtran Horizontal Transmittance")

end