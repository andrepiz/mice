function [vec_TO, q_FROM2TO] = convert_position_kernel(time_UTC, frame_FROM, frame_TO, vec_from, filename_metakernel)

%% SPICE KERNEL POOLING
load_metakernel(filename_metakernel)

%% CONVERT DATETIME TO ET
if isnumeric(time_UTC)
    et_UTC = time_UTC;
else
    et_UTC = cspice_str2et(cellstr(datestr(time_UTC)));
end

%% READ SPICE DATA
for ix = 1:size(vec_from, 2)
    dcm_FROM2TO_temp = cspice_pxform(frame_FROM, frame_TO, et_UTC); 
    vec_TO(:, ix) = dcm_FROM2TO_temp*vec_from(:, ix);
    q_FROM2TO(:, ix) = dcm_to_quat(dcm_FROM2TO_temp);
end

%% SPICE KERNEL UNLOADING
cspice_kclear;


