function radii = extract_radii_bodies_kernel(bodies_list, filename_metakernel)

if ischar(bodies_list)
    bodies_list = {bodies_list};
end

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% READ SPICE DATA
for ix = 1:length(bodies_list)
    radii(:, ix) = 1e3*cspice_bodvrd(bodies_list{ix}, 'RADII' , 3);
end

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end
