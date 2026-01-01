function [t_start_utc, t_end_utc] = check_coverage_kernel(kernelFilepath, kernelType, objectId, filename_metakernel)
% check_coverage_kernel - Check time coverage for SPK or CK kernel.
%   [t_start_utc, t_end_utc] = check_coverage_kernel(kernelFilepath, objectId, filename_metakernel, kernelType)
%
%   kernelFilepath:    Path to SPK/CK kernel
%   kernelType:        'SPK' or 'CK'
%   objectId:          NAIF ID of target (e.g. -203120 for DAWN_FC2)
%   filename_metakernel: Metakernel to load (should load LSK etc.)
%
%   Returns:
%     t_start_utc, t_end_utc: 1xN cell arrays with the coverage intervals (UTC string)

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% RETRIEVE COVERAGE
if ischar(objectId)
    objectCode = cspice_bods2c(objectId);
end
switch upper(kernelType)
    case 'SPK'
        cover = cspice_spkcov(kernelFilepath, objectCode, 1000);
    case 'CK'
        % Common CK parameters for full coverage; see doc for more options
        level = 'SEGMENT';
        needav = 0; % Only pointing, no angular velocity
        tol = 0;
        cover = cspice_ckcov(kernelFilepath, objectCode, needav, level, tol, 'TDB', 1000);
    otherwise
        error('Unsupported kernel type: %s. Use "SPK" or "CK".', kernelType);
end

if isempty(cover)
    error('The kernel does not contain data for the provided object.');
end

t_start_utc = strings(1, length(cover)/2);
t_end_utc   = strings(1, length(cover)/2);

for i = 1:2:length(cover)
    idx = (i+1)/2;
    t_start_utc(idx) = string(cspice_et2utc(cover(i), 'ISOC', 3));
    t_end_utc(idx)   = string(cspice_et2utc(cover(i+1), 'ISOC', 3));
    fprintf('Coverage window: %s   to   %s\n', t_start_utc(idx), t_end_utc(idx));
end

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end
