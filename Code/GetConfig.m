% FUNCTION NAME:
%   GetConfig
%
% DESCRIPTION:
%   Setting the tunable parameters of the program using global variables.
%   
%
% INPUT:
%   
% OUTPUT:
%
% ASSUMPTIONS AND LIMITATIONS:
%
%
%
% REVISION HISTORY:
%   Dates in DD/MM/YYYY
%
%   15/1/2023 - Sina Es haghi
%       * Initial implementation
%   01/2/2023 - Sina Es haghi
%       * Added new configuration properties
%   14/2/2023 - Sina Es haghi
%       * Screening box multiplier deleted and budget threshold modified
%   23/2/2023 - Sina Es haghi
%       * Upper and Lower bound time values for detection time and update interval have been introduced
%
function GetConfig

global config;

%% Propagation properties
config.timestep = 20;                                      % Propagation timestep [sec]
config.cycle_days = 3;                                     % No. of propagation date cycle limiter [days] (This is to avoid RAM overflow)
config.relevent_SO_frequency = 15;                         % Time period for relevant object update [days] (Again uses the MOID function)

%% Mean to True anomaly converter
config.tol = 1e-8;                                         % Function tolerance [rad]
config.maxIter = 10;                                       % Maximum number of iterations for Newton method

%% Conjunction screening
config.fine_prop_timestep = 1;                             % Fine propagation timestep in enlarged screening volume [sec]
config.superfine_prop_timestep = 0.1;                      % Super fine propagation timestep to find the exact time of TCA and the miss distance [sec]
config.screening_volume_type = 0;                          % If the screening volume is a box (0) or an ellipsoid (1)
config.conjunction_box = [2,25,25];                        % Conjunction box dimensions in RSW directions [km,km,km]
config.moid_distance = 200;                                % MOID threshold for finding relevant objects [km]

%% MOID calculation
config.FirstFilter = config.conjunction_box(1);            % Apogee and Perigee filtering to find the relevant objects efficiently [km] (Only works with secular J2 propagator)
config.Parallel_max_iter = 5;                              % Maximum number of iterations for parallel tuning

%% Conjunction Assessment and Risk Analysis process
config.detection_time = 7;                                 % Number of days prior to an event's TCA when the event is detected by the SSA provider [days]
config.detection_time_lower = config.detection_time- 1;   % Lower bound for random detection days prior to TCA [days]
config.detection_time_upper = config.detection_time+ 1;   % Upper bound for random detection days prior to TCA [days]
config.dt_default = 1;                                     % Process simulation default timestep [days] (discrete event simulation fixed timestep)

%% Technology model
config.government_SSA_updateInterval = 0.33;                  % The minimum time interval between two consecutive observations of the government SSA provider for the same event [days] (Assuming the 2 conjucting space objects are observable at the same time)
config.government_SSA_updateInterval_lower = ...           % Lower bound of minimum time interval [days]
    config.government_SSA_updateInterval*0.5;
config.government_SSA_updateInterval_upper = ...           % Upper bound of minimum time interval [days]
    config.government_SSA_updateInterval*1.5;
config.government_SSA_cov = ...                            % Covariance matrix provided by the government SSA provider [units in km^2 and km^2/s^2]
    diag([0.01^2 0.01^2 0.01^2 0.0001^2 0.0001^2 0.0001^2]);  

config.commercial_SSA_cost = 1;                            % Cost of requesting an observation by the commercial SSA provider [k$]
config.commercial_SSA_availability = 1; %0.8;                  % Availability of commercial SSA data when requested
config.commercial_SSA_updateInterval = 0.16;                % The minimum time interval between two consecutive observations of the commercial SSA provider for the same event [days] (Assuming the 2 conjucting space objects are observable at the same time)
config.commercial_SSA_updateInterval_lower = ...           % Lower bound of minimum time interval [days]
    config.commercial_SSA_updateInterval*0.5;
config.commercial_SSA_updateInterval_upper = ...           % Upper bound of minimum time interval [days]
    config.commercial_SSA_updateInterval*1.5;
config.commercial_SSA_cov = ...                            % Covariance matrix provided by the commercial SSA provider [units in km^2 and km^2/s^2]
    diag([0.001^2 0.001^2 0.001^2 0.00001^2 0.00001^2 0.00001^2]);  

%% Negative correlation factor
% config.rho_r_vs = -1;
% config.rho_s_vr = -1;
% 
% config.government_SSA_cov(1,5) = config.rho_r_vs * sqrt(config.government_SSA_cov(1,1)*config.government_SSA_cov(5,5));
% config.government_SSA_cov(5,1) = config.government_SSA_cov(1,5);
% config.government_SSA_cov(2,4) = config.rho_s_vr * sqrt(config.government_SSA_cov(2,2)*config.government_SSA_cov(4,4));
% config.government_SSA_cov(4,2) = config.government_SSA_cov(2,4);
% 
%% Other Initial Covariance matrix samples
% P0=diag([25 100 25 4e-4 1e-4 1e-4]); % Initial covariance matrix in RSW and [m^2 , m^2/s^2]
% P0(5,1) = -0.045;
% P0(4,2) = -0.18;
% 
% P0=diag([1 1 1 0 0 0]); % Initial covariance matrix in RSW and [m^2 , m^2/s^2]
% P0(5,1) = 0;
% P0(4,2) = 0;
% 
% config.government_SSA_cov = P0*1e-6;
% 
% config.rho_r_vs = -1;
% config.rho_s_vr = -1;
%
% config.commercial_SSA_cov(1,5) = config.rho_r_vs * sqrt(config.commercial_SSA_cov(1,1)*config.commercial_SSA_cov(5,5));
% config.commercial_SSA_cov(5,1) = config.commercial_SSA_cov(1,5);
% config.commercial_SSA_cov(2,4) = config.rho_s_vr * sqrt(config.commercial_SSA_cov(2,2)*config.commercial_SSA_cov(4,4));
% config.commercial_SSA_cov(4,2) = config.commercial_SSA_cov(2,4);

%% Size and Mass estimation for CDM generation (since RCS values are unavailable)
config.small_dim = 0.1;                                    % Maximum surface dimension of a small RCS object [m]
config.small_mass = 10;                                    % Mass of a small RCS object [kg]

config.medium_dim = 1;                                     % Maximum surface dimension of a medium RCS object [m]
config.medium_mass = 100;                                  % Mass of a medium RCS object [kg]

config.large_dim = 10;                                     % Maximum surface dimension of a large RCS object [m]
config.large_mass = 500;                                   % Mass of a large RCS object [kg]

config.HBRType = 'circle';                                 % Hard Body Radius type input for Pc calculation (Choose between 'circle', 'square', 'squareEquArea')

%% Vulnerability model (Secondary object properties, in case the object is a Payload)
config.small_value = 0.005;                                 % Monetized value of small RCS payload [same units as the NASA EOS values]
config.medium_value = 0.05;                                 % Monetized value of medium RCS payload [same units as the NASA EOS values]
config.large_value =0.5;                                     % Monetized value of large RCS payload [same units as the NASA EOS values]

%% Decision making model
config.CC_normalizer = 7000;                               % Number of pieces for normalizing the collision consequence (to have the CC value in the order of the object socio-economic values)

config.red_event_Pc = 1e-4;                                % Red category Pc threshold
config.yellow_event_Pc = 1e-7;                             % Yellow category Pc theshold
config.red_mitigation_days = 1;                            % Number of days before TCA to take mitigation action [days]

config.TimeToConj_high = 5;                                % Number of days threshold for the time to conjunction to be considered high [days]
config.TimeToConj_low = 2;                                 % Number of days threshold for the time to conjunction to be considered low [days]

config.value_high = 4.5;                                    % Collision value threshold for a conjunction to be considered high value
config.value_low = 3;                                      % Collision value threshold for a conjunction to be considered low value

config.budget_per_day = 5;                                 % Budget available for NASA CARA to request commercial observation, per day [Units are in the same norm as monetized value]

config.budget_tres = 0.5;                                  % Fraction threshold of the total budget so the available budget is considered high or low




