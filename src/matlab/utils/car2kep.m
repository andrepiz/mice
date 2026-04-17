function [a, e, i, OM, om, th] = car2kep(r, v, mu)

% DESCRIPTION: 
% Conversion from Cartesian coordinates to Keplerian elements.
% Angles in radians. 
%
% INPUT: 
% r [3x1] Position vector [km] 
% v [3x1] Velocity vector [km/s] 
% mu [1x1] Gravitational parameter [km^3/s^2]
%           (default value of Earth, if you have a different focal centre
%           please specify the value)
%
% OUTPUT: 
% a [1x1] Semi-major axis [km] 
% e [1x1] Eccentricity [-] 
% i [1x1] Inclination [rad] 
% OM [1x1] RAAN [rad] 
% om [1x1] Pericentre anomaly [rad] 
% th [1x1] True anomaly [rad]

if nargin<3
  mu = 398600.433;
end

h = cross(r,v); % define specific angular moment

%% define inclination

i = acos(h(3,1)/norm(h));  
% se il vettore h è 3x1, se no usare h(1,3)

%% define eccentricity

e = 1/mu*(((norm(v))^2-mu/norm(r))*r - (dot(r,v))*v); 
eps = 0.5*(norm(v))^2 - mu/norm(r); 

%% define semi-major axis

a = - mu/(2*eps); 

%% define RAAN

K = [0;0;1]; % define K-versor
N = cross(K,h); % define node-line
if N(2,1) < 0 
    OM = 2*pi - acos(N(1,1)/(norm(N)));
else 
    OM = acos(N(1,1)/(norm(N))); 
end

%% define pericentre anomaly

if e(3,1) < 0 
    om = 2*pi - atan2(norm(cross(N,e)),dot(N,e));
else 
    om = atan2(norm(cross(N,e)),dot(N,e));
end

%% define true anomaly

vr = (dot(r,v))/norm(r); % define radial speed
if vr < 0 
    th = 2*pi - atan2(norm(cross(e,r)),dot(e,r));
else
    th =  atan2(norm(cross(e,r)),dot(e,r));
end


%% scalari

e=norm(e);
end

