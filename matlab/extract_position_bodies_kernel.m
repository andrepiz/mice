function [pos_ECI, vel_ECI] = extract_position_bodies_kernel(time_UTC, bodies_list, filename_metakernel)

%% SPICE KERNEL POOLING
load_metakernel(filename_metakernel)

%% CONVERT DATETIME TO ET
if isnumeric(time_UTC)
    et_UTC = time_UTC;
else
    et_UTC = cspice_str2et(cellstr(datestr(time_UTC)));
end

%% READ SPICE DATA
for ix = 1:length(bodies_list)
    state_temp = cspice_spkezr(bodies_list{ix}, et_UTC, 'J2000', 'LT+S', 'EARTH');
    pos_ECI(3*(ix-1) + [1:3], :) = 1e3*state_temp(1:3, :);
    vel_ECI(3*(ix-1) + [1:3], :) = 1e3*state_temp(4:6, :);
end

%% SPICE KERNEL UNLOADING
cspice_kclear;

end
