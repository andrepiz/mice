function kep = propagate_position_keplerian(kep0, time_UTC, mu_sun, filename_metakernel)
%PROPAGATE_POSITION_KEPLERIAN Propagates Keplerian elements to given times.
%
% Inputs:
%   kep0                - 6x1 initial Keplerian elements [a; e; i; RAAN; argp; nu0] (angles in radians)
%   time_UTC            - Vector of times (datetime or ET seconds past J2000)
%   mu_sun              - Gravitational parameter of the Sun [km^3/s^2]
%   filename_metakernel - Path to SPICE metakernel
%
% Output:
%   kep - Nx6 matrix of Keplerian elements at each time (only true anomaly changes)
%
% Author: Andrea Pizzetti
% Date: June 6, 2025

%% Load SPICE kernels
tempPath = load_metakernel(filename_metakernel);

% Convert time to ET seconds past J2000 if needed
if isnumeric(time_UTC)
    et_vec = time_UTC(:);  % ensure column vector
else
    et_vec = cspice_str2et(cellstr(datestr(time_UTC(:))));
end

%% Extract initial Keplerian elements
a    = kep0(1);  % semi-major axis [km]
e    = kep0(2);  % eccentricity
i    = kep0(3);  % inclination [rad]
RAAN = kep0(4);  % right ascension of ascending node [rad]
argp = kep0(5);  % argument of periapsis [rad]
nu0  = kep0(6);  % initial true anomaly [rad]

% Compute mean motion
n = sqrt(mu_sun / a^3); % [rad/s]

% Initial eccentric anomaly
E0 = 2 * atan( sqrt((1 - e)/(1 + e)) * tan(nu0 / 2) );
if E0 < 0
    E0 = E0 + 2*pi;
end

% Initial mean anomaly
M0 = E0 - e * sin(E0);

% Time offset from reference epoch
dt = et_vec - et_vec(1); % [s]

% Mean anomaly at each time
M = M0 + n * dt;

% Solve Kepler's equation for each M
E = arrayfun(@(Mk) solve_kepler(Mk, e), M);

% Compute true anomalies
nu = 2 * atan2( sqrt(1 + e) .* sin(E / 2), sqrt(1 - e) .* cos(E / 2) );
nu = mod(nu, 2*pi);  % Normalize to [0, 2π)

% Assemble full Keplerian element matrix
nt = length(et_vec);
kep = [repmat([a; e; i; RAAN; argp], 1, nt); nu];

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end

%% Helper function to solve Kepler’s equation
function E = solve_kepler(M, e)
% Solves Kepler's equation M = E - e*sin(E) using Newton-Raphson

    tol = 1e-10;
    E = M; % Initial guess

    for iter = 1:100
        f = E - e * sin(E) - M;
        fp = 1 - e * cos(E);
        dE = -f / fp;
        E = E + dE;
        if abs(dE) < tol
            break;
        end
    end

end
