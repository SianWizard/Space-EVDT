function state_car = par2car(state_kep)
%% Orbital mechanics course A.Y. 2020/2021
% Developed by: Group 37
% Sina Es haghi       10693213
% Giulia Sala         10582449
% Valerio Santolini   10568153
% Pietro Zorzi        10607053
%
%PROTOTYPE:
%[r_vect, v_vect] = par2car(kep, mu_E)
%
%% This function will compute the cartesian parameters ECI reference frame from the keplerian ones
% Inputs:
% kep [6x1] Keplerian parameters [km;-;rad;rad;rad;rad]

% Outputs:
% state_car [6x1] = [r;v]

%mu_E=astroConstants(13);
mu_E=3.986004330000000e+05;

a = state_kep(1);
e = state_kep(2);
i = state_kep(3);
OM = state_kep(4);
om = state_kep(5);
th = state_kep(6);

p=a.*(1-e.^2);
r=p./(1+e.*cos(th));
rr=[r.*cos(th), r.*sin(th), 0];
vr=sqrt(mu_E./p).*e.*sin(th);
vth=sqrt(mu_E./p).*(1+e.*cos(th));
vv=[vr.*cos(th)-vth.*sin(th), vr.*sin(th)+vth.*cos(th), 0];
%scrittura delle matrici di rotazione
ROM=[cos(OM), sin(OM), 0; -sin(OM), cos(OM), 0; 0, 0, 1];
Rom=[cos(om), sin(om), 0; -sin(om), cos(om), 0; 0, 0, 1];
Ri=[1, 0, 0; 0, cos(i), sin(i); 0, -sin(i), cos(i)];
RR=Rom*Ri*ROM;
rr=rr';
vv=vv';
rr=RR'*rr;
vv=RR'*vv;
state_car=[rr;vv];