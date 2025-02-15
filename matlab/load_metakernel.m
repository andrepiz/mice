function load_metakernel(filename_metakernel, path_metakernel)
% Load a metakernel in the SPICE pools assuming MICE is installed in the
% system and 

if nargin == 0
    filename_metakernel = 'default.tm';
    try
        path_metakernel = fullfile(mice_home(), 'kernels');
    catch
        error('MICE not found in the system. Please provide the path to MICE code.')
    end
elseif nargin == 1
    try
        path_metakernel = fullfile(mice_home(), 'kernels');
    catch
        error('MICE not found in the system. Please provide the path to MICE code.')
    end
end

d = pwd;
cd(path_metakernel)
cspice_furnsh(filename_metakernel);
cd(d);

end