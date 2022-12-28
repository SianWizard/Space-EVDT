classdef CDM
    properties
        label               % Label of the Conjunction Data Message
        creation_date       % The CDM creation date [yyyy mm dd hr min sec]
        tca                 % The time of closest approach [yyyy mm dd hr min sec]
        miss_dist           % Miss distance [km]
        Pc                  % Probability of collision
        CC                  % Collision consequence number of pieces
        catas_flag          % Catastrophy flag [bool]
        HBR                 % Hard body radius [km]
        
        id1                 % NORAD id of object 1
        r1                  % Position vector of object 1
        v1                  % Velocity vector of object 1
        cov1                % Covariance matrix of object 1 at TCA [km^2 and km^2/s^2]
        dim1                % Maximum cross section area of object 1 [m^2] 
        m1                  % Mass of object 1 [kg]
        
        id2                 % NORAD id of object 2
        r2                  % Position vector of object 2
        v2                  % Velocity vector of object 2
        cov2                % Covariance matrix of object 2 at TCA [km^2 and km^2/s^2]
        dim2                % Maximum cross section area of object 2 [m^2] 
        m2                  % Mass of object 2 [kg]

    end
end

