function [lon, lat] = extract_ecliptic_lonlat_kernel(time_UTC, bodies_list, filename_metakernel, ltscorrection)

if ~exist('ltscorrection','var')
    ltscorrection = 'NONE';
end

if ischar(bodies_list)
    bodies_list = {bodies_list};
end

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% CONVERT DATETIME TO ET
if isnumeric(time_UTC)
    et_UTC = time_UTC;
else
    et_UTC = cspice_str2et(cellstr(datestr(time_UTC)));
end

%% READ SPICE DATA
for ix = 1:length(bodies_list)
    state_temp = cspice_spkezr(bodies_list{ix}, et_UTC, 'ECLIPJ2000', ltscorrection, 'SUN');
end
sph = sph_coord(state_temp(1:3, :));
lon = sph(2, :);
lat = sph(3, :);

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end
