% Making a surface for 3D printing using MatLAB in cylindrical coordinates
% By Eric Landahl, November 17, 2014
% Revised October 27, 2017 to simplify, add polar angle, and examples
% See http://jmumakerlab.blogspot.com/2013/11/exporting-stl-from-matlab.html
% Uses the functions surf2solid and stlwrite
clear all;

numpts_r = 100; % Number of radial points
numpts_phi = 100; % Number of polar points

Rmax = 20; % Maximum radius (usually in mm)
PHImax = 2*pi; % Maximum azimuthal angle (usually 2*pi)

Zmin=-20.0; % Smallest z value to be printed (useful for diverging functions)
Zmax = 20.0; % Largest z value to be printed (useful for diverging functions)

r = eps + 0:Rmax/numpts_r:Rmax;
phi = 0:PHImax/numpts_phi:PHImax;

[R PHI] = meshgrid(r,phi);

%% Example:  1/R (e.g. gravitational potential)
%Z = -10./R;


%% Example:  Spiral
%Z = 3*PHI;

%% Example: Vibrating membrane
% see https://math.dartmouth.edu/archive/m23f09/public_html/drum.pdf
% Requires the function besselzero.m
n = 2; % polar mode number, n = 0, 1, 2, ...
k = 3; % radial mode number, k = 1, 2, 3, ...
lambda = besselzero(n,k,1); % k-th zero of n-th bessel function of first kind
Z = (Rmax/3)*besselj(n,lambda(k)*R/Rmax).*cos(n*PHI);

%% Generate X and Y coordinates
X = R.*cos(PHI);
Y = R.*sin(PHI);

% Truncate surface below Zmin
Z=(Z>=Zmin).*Z + (Z<Zmin).*Zmin;

% Truncate surface above Zmax
Z=(Z<=Zmax).*Z + (Z>Zmax).*Zmax;

figure(1);clf; hold on;
surf(X,Y,Z)
hold off;

mysurface=surf2solid(X,Y,Z);
stlwrite('mysurface.stl',mysurface)


