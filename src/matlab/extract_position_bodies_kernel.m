function [pos_ECI, vel_ECI] = extract_position_bodies_kernel(time, bodies_list, filename_metakernel, abcorr, obs)

if ~exist('abcorr','var')
    abcorr = 'LT+S';
end
if ~exist('obs','var')
    obs = 'EARTH';
end

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% CONVERT DATETIME TO ET
if isnumeric(time)
    et_UTC = time;
else
    et_UTC = cspice_str2et(cellstr(datestr(time)));
end

%% READ SPICE DATA
if ~iscell(bodies_list)
    bodies_list = {bodies_list};
end
for ix = 1:length(bodies_list)
    state_temp = cspice_spkezr(bodies_list{ix}, et_UTC, 'J2000', abcorr, obs);
    pos_ECI(3*(ix-1) + [1:3], :) = 1e3*state_temp(1:3, :);
    vel_ECI(3*(ix-1) + [1:3], :) = 1e3*state_temp(4:6, :);
end

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end
