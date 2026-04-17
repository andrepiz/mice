function [rr, vv] = kep2car(kepEl,mu_p)

% Transformation from Keplerian elements to cartesian coordinates
% function [rr, vv] = kep2car(a, e, i, OM, om, th, mu)
%
% INPUT
% Keplerian elements of the orbit kepEl = [a e i OM om th]; 
% a      [1x1]  Semi-major axis                                  [km]
% e      [1x1]  Eccentricity                                     [-]
% i      [1x1]  Inclination                                      [rad]
% OM     [1x1]  RAAN (Right ascension of the ascending node)     [rad]
% om     [1x1]  Argument of perigee                              [rad]
% th     [1x1]  True anomaly                                     [rad]

% OUTPUT
% rr     [3x1]  Position vector                                  [km]
% vv     [3x1]  Velocity vector                                  [km/s]


a = kepEl(1); 
e = kepEl(2);
in = kepEl(3); 
OM = kepEl(4); 
om = kepEl(5); 
th = kepEl(6); 


p=a*(1-e^2); % Semi-latus rectum [km]
c_th = cos(th);
s_th = sin(th);
r_p=(p/(1+e*c_th))*[c_th; s_th; 0]; % Position vector (perifocal coordinate (PQW) system) [km]

v_p= sqrt(mu_p/p)*[-s_th; e+c_th; 0]; % Velocity vector (perifocal coordinate (PQW) system) [km/s]

% Rotation around K of an OM angle
c_OM = cos(OM);
s_OM = sin(OM);
R_OM=[c_OM, -s_OM, 0;...
    s_OM ,c_OM, 0;...
    0, 0, 1];

% Rotation around I' of an i angle
c_in = cos(in);
s_in = sin(in);
R_i=[1, 0, 0;
    0, c_in, -s_in;...
    0, s_in, c_in];

% Rotation around K'' of an om angle
%     R_om=[cos(om+th) sin(om+th) 0
%         -sin(om+th) cos(om+th) 0
%         0 0 1];
c_om = cos(om);
s_om = sin(om);
R_om=[c_om, -s_om, 0;...
        s_om ,c_om, 0;...
        0, 0,1];

R=R_OM*R_i*R_om; % Transformation matrix from GE to PF

 
rr=R*r_p; % Position vector (geocentric coordinates) [km]
vv=R*v_p; % Velocity vector (geocentric coordinates) [km/s]

end