function q_ECI2IAU = extract_orientation_bodies_kernel(time_UTC, bodies_list, filename_metakernel)

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
    dcm_IAU2ECI_temp = cspice_pxform(['IAU_', bodies_list{ix}], 'J2000', et_UTC);
    q_ECI2IAU(:, :, ix) = quat_conj(dcm_to_quat(dcm_IAU2ECI_temp));
end

%% SPICE KERNEL UNLOADING
cspice_kclear;

end
