% FUNCTION NAME:
%   Event_detection
%
% DESCRIPTION:
%   This function first finds the relevant space objects to the EOS satellite under consideration.
%   The relevant space objects along with the NASA satellite are propagated for the number of days specified.
%   The propagation is carried out with a fixed timestep and using the analytic secular J2 propagator.
%   Since there is a chance of RAM overflowing, the program runs the event detection is sections of 
%   half days, clearing all the propagation data and only saving the conjunction event basic details.
%   
%
% INPUT:
%   Satellite = (1 object) Primary NASA satellites under consideration for collision avoidance [NASA_sat]
%   space_cat = (M objects) Space catalogue fed to the program as the space environment [Space_object]
%   epoch = [1x6] Simulation start date in Gregorian calender [yy mm dd hr mn sc]
%   no_days = [1x1] Simulation number of days after epoch [days]
%   event_list = (F objects) List of conjunction events detected by the program, not in a sorted way [Conjunction_event]
%   space_cat_ids = [1xM] A matrix containing the NORAD IDs of the space catalogue objects in order
%   
% OUTPUT:
%   event_list = (P objects) List of conjunction events detected by the program, not in a sorted way [Conjunction_event]
%
% ASSUMPTIONS AND LIMITATIONS:
%   It is suggested that the timestep not be higher than 15 seconds, otherwise conjunctions may be missed.
%   Remember that number of events in event_list must increase or stay constant after the simulation (F<=P)
%
%
%
% REVISION HISTORY:
%   Dates in DD/MM/YYYY
%
%   11/1/2023 - Sina Es haghi
%       * Adding header
%   01/2/2023 - Sina Es haghi
%       * Cleaned up the code a bit
%

function [event_list,Relevant_object_list] = Event_detection (Satellite,space_cat,epoch,no_days,event_list)

%global config;
config = GetConfig;
%%

if nargout == 2
    Relevant_object_list(length(space_cat)) = Space_object;
    list_length = 0;
end


%% Finding primary sat in space catalogue and initial relevant space objects
%finding the index in the space catalogue

sat_index=NaN;
for i=1:length(space_cat)
    if strcmp(Satellite.name,space_cat(i).name)
        sat_index=i;
        break;
    end
end

if isnan(sat_index)
    error('Satellite name not found in the space catalogue')
end

Primary=space_cat(sat_index);

%% Big Loop for avoiding ram overflow

initial_date=date2mjd2000(epoch);

cycle_days=config.cycle_days; % Time sections to avoid RAM overflow

if config.TPF == 1
    cycle_days = no_days+1;
end

time_cycle = initial_date:cycle_days:initial_date+no_days;
relevent_SO_frequency=config.relevent_SO_frequency; % Renews the relevant space objects every 5 days

time_cycle(end+1)=initial_date+no_days;

timestep = config.timestep;



for cycle=1:length(time_cycle)-1

    initial_date=mjd20002date(time_cycle(cycle));
    final_date=mjd20002date(time_cycle(cycle+1));

    Primary = Space_catalogue_reset_epoch (Primary,initial_date);

    % This is to renew the relevant space objects after the specified number of days
    if rem(cycle,ceil(relevent_SO_frequency/cycle_days))==0 || cycle==1
        space_cat = Space_catalogue_reset_epoch (space_cat,initial_date);
        Relevant_space_objects= MOID(Primary,space_cat);

        %% Adding to the relevant object list
        if nargout==2
            for pl = 1:length(Relevant_space_objects)
                exist = 0;
                for dh = 1:list_length
                    if Relevant_object_list(dh).id == Relevant_space_objects(pl).id
                        exist =1;
                    end
                end
                if exist == 0
                    list_length = list_length+1;
                    Relevant_object_list(list_length)=Relevant_space_objects(pl);
                end
            end
        end

    else
        Relevant_space_objects = Space_catalogue_reset_epoch (Relevant_space_objects,initial_date);
    end

    if config.TPF == 1
        %% Time Prefilter applied
        temp_list = cell(length(Relevant_space_objects),1);
        parfor ok=1:length(Relevant_space_objects) % Can be parfor

            fake_event = Conjunction_event;
            fake_event = time_prefilter_candidates (Primary,Relevant_space_objects(ok),config.moid_distance,initial_date,final_date,fake_event,config);

            if length(fake_event)==1 && isempty(fake_event(1).id)
                continue;
            end

            temp_list{ok}=fake_event;
        end
        temp_list = temp_list(~cellfun('isempty',temp_list));
        if ~isempty(temp_list)
            if length(event_list)==1 && isempty(event_list(1).id)
                event_list = temp_list{1};
                for kj=2:length(temp_list)
                    event_list = [event_list temp_list{kj}];
                end
            else
                for kj=1:length(temp_list)
                    event_list = [event_list temp_list{kj}];
                end
            end
        end
    else
        %% Brute Force
        Propagated_primary = main_propagator (Primary,final_date,timestep,1);
        Propagated_Relevant_space_objects  = main_propagator (Relevant_space_objects,final_date,timestep,1);
        event_list = conj_assess (Propagated_primary, Propagated_Relevant_space_objects,event_list,config);
        clear Propagated_primary;
        clear Propagated_Relevant_space_objects;
    end
end
if nargout == 2
    Relevant_object_list(list_length+1:end) = [];
end


