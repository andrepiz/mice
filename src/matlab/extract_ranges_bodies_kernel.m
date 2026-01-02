function [ranges, rr_beacons] = extract_ranges_bodies_kernel(rr_observer, time_UTC, bodies_list, filename_metakernel, ltscorrection, origin, frame)
% EXTRACT_RANGES_BODIES_KERNEL Computes ranges to selected beacons.
%
% Inputs:
%   rr_observer       - 3 x N_times matrix of observer positions [km]
%   time_UTC          - 1 x N_times vector of ephemeris times or dates (SPICE ET seconds past J2000)
%   bodies_list       - Cell array of beacon names (must match SPICE IDs)
%   filename_metakernel - SPICE metakernel filename (string)
%   ltscorrection     - Light time correction string (optional, default: 'NONE')
%   origin            - Reference frame origin (optional, default: 'EARTH')
%   frame             - Reference frame (optional, default: 'J2000')
%
% Outputs:
%   ranges         - 1 x N_times x N_beacons array of LoS unit vectors
%   rr_beacons     - 3 x N_times x N_beacons array of beacon positions
%
% Author: Andrea Pizzetti
% Date: June 6, 2025

if ~exist('ltscorrection','var') || isempty(ltscorrection)
    ltscorrection = 'NONE';
end

if ~exist('origin','var') || isempty(origin)
    origin = 'EARTH';
end

if ~exist('frame','var') || isempty(frame)
    frame = 'J2000';
end

if ischar(bodies_list)
    bodies_list = {bodies_list};
end

%% SPICE KERNEL LOADING

% Preallocate outputs as 3D arrays
nt = length(time_UTC);
nb = length(bodies_list);
ranges = zeros(1, nt, nb);
rr_beacons = zeros(3, nt, nb);

% Loop over times and beacons to compute LoS
for ix = 1:nb
    % Extract position of the beacon at current time
    rr_beacons(:, :, ix) = extract_position_bodies_kernel(time_UTC, bodies_list{ix}, filename_metakernel, ltscorrection, origin, frame);
    loses_beacon = rr_beacons(:, :, ix) - rr_observer;
    ranges(:, :, ix) = vecnorm(loses_beacon);
end

end
