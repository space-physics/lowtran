function plot_transmission(T)
trans = squeeze(xarray2mat(T{'transmission'}));
wl_nm = xarray2mat(T{'wavelength_nm'});

figure
semilogy(wl_nm, trans(:,1))
ylim([1e-4,1])
xlabel('wavelength (nm)')
ylabel('transmittance')

end