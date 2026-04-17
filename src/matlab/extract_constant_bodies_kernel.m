function C = extract_constant_bodies_kernel(idConstant, sizeConstant, bodies_list, filename_metakernel)

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% READ SPICE DATA
if ~iscell(bodies_list)
    bodies_list = {bodies_list};
end
for ix = 1:length(bodies_list)
    C(ix) = cspice_bodvrd(bodies_list{ix}, idConstant , sizeConstant);  
end

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end
