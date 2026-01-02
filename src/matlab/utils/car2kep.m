function [a, e, i, OM, om, th] = car2kep(rr, vv, mu)
% car2kep converts the Cartesian coordinates to Keplerian coordinates 
% 
% INPUTS: 
% rr [3xN]   : Position vector [m]
% vv [3xN]   : Velocity vector [m/s]
% mu [1]     : Standard Gravitational parameter [m^3/s^2]
%
% OUTPUTS: 
% a [1]      : Semi-Major Axis [m]                          [0,inf]
% e [1]      : Eccentricity [~]                             [0,1)
% i [1]      : Inclination [rad]                            [-pi,pi]
% OM [1]     : Right Ascension of Ascending Node [rad]      [0,2pi]
% om [1]     : Argument of Perigee [rad]                    [0,2pi]
% th [1xN]   : True Anomaly [rad]                           [0,2pi]       

% tolerances for singularities
tol_i = 1e-10;        
tol_e = 1e-12;

% number of points
n = size(rr,2);

% position and velocity norm
r = cp_norm(rr);
v = cp_norm(vv);
% energy
E = 0.5*v.^2-mu./r;
% momentum
hh = cross(rr,vv);
h = cp_norm(hh);

% semi-major axis
a = -mu./(2*E);

% eccentricity
ee = cross(vv,hh)/mu-rr./r;
e = cp_norm(ee);
ixs_circ = e < tol_e;  % saving indexes of zero eccentricity
if any(ixs_circ)
    e(ixs_circ) = 0;
end

% inclination
% https://en.wikipedia.org/wiki/Orbital_inclination
i = acos(hh(3,:)./h); 
ixs_equat = abs(i) < tol_i; % saving indexes of null inclination
if any(ixs_equat)
    i(ixs_equat) = 0;
end

% RAAN
% https://en.wikipedia.org/wiki/Longitude_of_the_ascending_node
K = repmat([0;0;1],1,n);                  % +z eci
N = cross(K,hh);                          % ascending node (perpendicular to +z eci and h vector)
N_norm = N./cp_norm(N);
OM = acos(N_norm(1,:));    
ixs_OM = N(2,:)<0;
OM(ixs_OM) = 2*pi-OM(ixs_OM);
if any(ixs_equat)
    % singularity: setting N aligned to +x eci and RAAN = 0 for equatorial orbits
    N(:,ixs_equat) = h(ixs_equat).*[1;0;0];
    N_norm = repmat([1;0;0],1,n); 
    OM(ixs_equat) = 0;    
end

% Argument of perigee
% https://en.wikipedia.org/wiki/Argument_of_periapsis
om = acos(cp_sat(dot(N_norm,ee)./e,-1,1)); 
ixs_om = ee(3,:)<0;      % always positive RAAN
om(ixs_om) = 2*pi-om(ixs_om);
if any(ixs_equat)
    % singularity: 2D case for equatorial orbits
    om(ixs_equat) =  atan2(ee(2,ixs_equat),ee(1,ixs_equat)); % equatorial case
    ixs_om_2 = hh(3,:)<0;
    om(ixs_equat & ixs_om_2) = 2*pi-om(ixs_equat & ixs_om_2);
end

% True anomaly
% https://en.wikipedia.org/wiki/True_anomaly
th = acos(cp_sat(dot(rr,ee)./(r.*e),-1,1));
ixs_th = dot(vv,rr)<0;
th(ixs_th) = 2*pi-th(ixs_th);      % always positive true anomaly
if any(ixs_circ)
    % singularity: circular orbits and equatorial orbits 
    om(ixs_circ) = 0;
    th(ixs_circ) = acos(max(-1,min(1,(dot(rr(:,ixs_circ),N_norm(:,ixs_circ)))./(r(ixs_circ)))));
    % circular but not equatorial
    ixs_th = rr(3,ixs_circ & ~ixs_equat)<0;
    th(ixs_circ & ~ixs_equat & ixs_th) = 2*pi-th(ixs_circ & ~ixs_equat & ixs_th);
    % circular and equatorial
    ixs_th = vv(1,ixs_circ & ixs_equat)>0;
    th(ixs_circ & ixs_equat & ixs_th) = 2*pi-th(ixs_circ & ixs_equat & ixs_th);
end

% ixs_asc = vv(3,:)>0;
% ixs_flip = dot(rr(:,ixs_asc),N_norm(:,ixs_asc))<0 || dot(rr(:,~ixs_asc),N_norm(:,~ixs_asc))>0;
% if any(ixs_flip)
%     i(ixs_flip) = -i(ixs_flip);
%     OM(ixs_flip) = OM(ixs_flip)+pi;
%     om(ixs_flip) = om(ixs_flip)+pi;
% end 
end