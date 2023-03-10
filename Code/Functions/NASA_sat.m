%% NASA Satellite info

classdef NASA_sat
    properties
        id                      % NORAD ID
        name                    % Name of the satellite
        dimensions              % Array of satellite dimensions [m] or up to [m,m,m]
        mass                    % Satellite mass [kg]
        cost                    % Production and launch cost of the satellite [million $]
        science                 % Science areas that the satellite is producing data in
        applications            % Application areas that the satellite is producing data in
        no_instruments          % Number of instruments onboard the satellite
        instruments             % Instrument names onboard the satellite
        value                   % Value of the satellite assigned by the Vulnerability model
    end
end