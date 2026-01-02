function [rr, vv] = kep2car(a, e, i, OM, om, th, mu)
% kep2car converts Keplerian elements to Cartesian coordinates (ECI)
%
% INPUTS: 
% a   [Nx1] : Semi-Major Axis [m]
% e   [Nx1] : Eccentricity [~]
% i   [Nx1] : Inclination [rad]
% OM  [Nx1] : RA of Ascending Node [rad]
% om  [Nx1] : Argument of Periapsis [rad]
% th  [Nx1] : True Anomaly [rad]
% mu  [1]   : Gravitational parameter [m^3/s^2]
%
% OUTPUTS: 
% rr [3xN]  : Position vectors [m]
% vv [3xN]  : Velocity vectors [m/s]

% Ensure column vectors
a = a(:); e = e(:); i = i(:);
OM = OM(:); om = om(:); th = th(:);

N = length(a);

% Specific angular momentum
p = a .* (1 - e.^2);      % [m]
r = p ./ (1 + e .* cos(th));  % [m]

% Position in perifocal frame
R_pf = [r .* cos(th), r .* sin(th), zeros(N,1)]';  % 3xN

% Velocity in perifocal frame
V_pf = sqrt(mu ./ p)' .* [-sin(th), e + cos(th), zeros(N,1)]';  % 3xN

% Allocate outputs
rr = zeros(3, N);
vv = zeros(3, N);

% Compute transformation matrices and apply
for k = 1:N
    % Rotation matrices
    R_OM = [cos(OM(k)), sin(OM(k)), 0;
           -sin(OM(k)), cos(OM(k)), 0;
                     0,          0, 1];

    R_i = [1,      0,           0;
           0, cos(i(k)),  sin(i(k));
           0, -sin(i(k)), cos(i(k))];

    R_om = [cos(om(k)), sin(om(k)), 0;
           -sin(om(k)), cos(om(k)), 0;
                      0,          0, 1];

    T = (R_OM * R_i * R_om)';  % transpose = from perifocal to inertial

    % Apply transformation
    rr(:,k) = T * R_pf(:,k);
    vv(:,k) = T * V_pf(:,k);
end

end
