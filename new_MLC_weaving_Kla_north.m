%========================================================================
% Created on Fri Feb 01 18:41:00 2019
% Topic: Find gaps which trucks accept for MLC
% Dataset: Helicopter trjectory data from Aries van Beinum 
% @author: salilsharma

% A. van Beinum et al. "Driving behaviour at motorway ramps and weaving 
% segments based on empirical trajectory data". In: Transportation Research
% Part C: Emerging Technologies 92 (2018), pp. 426-441.
%========================================================================

clear; clc;

%Load a bootleneck section
site='weaving_Klaverpolder_north';
filename=strcat(site,'_trajectories.mat');
load(filename);

%Load leader-follower data
load(strcat(site,'_leader_follower.mat'));

%Load site characteristics file
load(strcat(site,'_lanes.mat'));
x_min = lanes.nose1;
ramp_length = lanes.ramp_length;
x_max = x_min + ramp_length;

counter1=[];
counter2=[];

%Filter trucks
ids=find([trajectories.l]>=12)';
for j=1:length(ids)
    i=ids(j);
    %store lanes vector as lanetraj
    lanetraj=[];
    lanetraj=trajectories(i).lanes;
    %start at ramp lane
    if lanetraj(1) == -1 & lanetraj(end) == 1
        if lanetraj(end) > -1
            counter1=[counter1;i];
        end
    %end at ramp lane
    elseif lanetraj(end) == -1
        if lanetraj(1) > -1
            counter2=[counter2;i];
        end
    % No need to consider DLC
    else
        continue;
    end
end

%% Produce plots of lane change duration

counter=counter1;

%introduce a binary outcome variable alpha to capture left or right lane
%change maneuvers 
%alpha=1, if lane changes to the right
%alpha=-1, if lane changes to the left

if isequal(counter, counter1)
    alpha=-1;
    beta=1;
else
    alpha=1;
    beta=3;
end

Truck_lane_change_data=[];
false_id = [4, 17, 19];
removal_id = [];
for k=1:length(counter)
    if ismember(k, removal_id)
        continue
    end
    %figure(1); hold on;
    l=counter(k);
    smooth_traj=smooth(trajectories(l).y_sm,40,'moving');
    %smooth_traj=trajectories(l).y_sm;
    %pt is of interest
    [pt,id]=findchangepts(smooth_traj);
    %Maxima
    [ptmax,idmax]=findpeaks(alpha.*smooth_traj);
    %Minima
    [ptmin,idmin]=findpeaks(alpha.*-smooth_traj);
    %Create maxima and minima array
    %For on ramp, maxima occurs after changepoint
    max_array=idmax(idmax>pt);
    min_array=idmin(idmin<pt);
    if isempty(max_array) || isempty(min_array)
        if isempty(min_array)
            min_array=1;
        end
        if isempty(max_array)
            %temp=[];
            %temp=lenth()trajectories(l).t;
            max_array=length(trajectories(l).y_sm);
        end
        lane_change_initiation = min_array(end);
        lane_change_completion = max_array(1);
%         %Use change point to refine end point of a lane change process
%         L1 = pt-lane_change_initiation;
%         L2 = lane_change_completion-pt;
%         
%         if L1 <= (L2-5)
%             lane_change_completion = pt + L1;
%         elseif L1 > (L2+5)
%             lane_change_initiation = pt - L2;
%         else
%             continue;
%         end
%         
%         lag_gap=trajectories_lf(l).foll_s_nett(lane_change_initiation,beta)
%         lane_change_duration = (lane_change_completion-lane_change_initiation)./10;
%         % Check speed_at_merge and relative position of merge location
%         speed_at_merge = trajectories(l).v_cal(lane_change_completion);
%         %extend to relative location in future
%         merge_location = trajectories(l).x_sm(lane_change_initiation);
%         %merge_location = trajectories(l).x_sm(lane_change_completion);
%         Truck_lane_change_data=[Truck_lane_change_data;l,lane_change_duration, lag_gap, speed_at_merge, merge_location];
    else
        lane_change_initiation = min_array(end);
        lane_change_completion = max_array(1);
    end


    %Use change point to refine end point of a lane change process
    L1 = pt-lane_change_initiation;
    L2 = lane_change_completion-pt;

    if L1 <= (L2-5)
        lane_change_completion = pt + L1;
    elseif L1 > (L2+5)
        lane_change_initiation = pt - L2;
    else
        pt;
    end
    
    if ismember(k,false_id)
        if k==4
            lane_change_initiation = 73;
            lane_change_completion = 311;
        elseif k==17
            lane_change_initiation = 1;
            lane_change_completion = 91;
        else
            lane_change_initiation = 35;
            lane_change_completion = 95;
        end
    else
        k;
    end
lag_gap=trajectories_lf(l).foll_s_nett(lane_change_initiation,beta);
    if (lag_gap)<=-0
        lag_gap = 250;
    end
    lead_gap=trajectories_lf(l).lead_s_nett(lane_change_initiation,beta);
    if (lead_gap)<=-0
        lead_gap = 250;
    end
    critical_gap = lag_gap + lead_gap;
    if (trajectories(l).x_sm) < x_min
       l 
    end
    max_lag_gap=max(trajectories_lf(l).foll_s_nett(1:lane_change_initiation,beta));
    if (max_lag_gap)<=-0
        max_lag_gap = 250;
    end
    min_lag_gap=min(trajectories_lf(l).foll_s_nett(1:lane_change_initiation,beta));
    if (min_lag_gap)<=-0
        min_lag_gap = 250;
    end
    max_lead_gap=max(trajectories_lf(l).lead_s_nett(1:lane_change_initiation,beta));
    if (max_lead_gap)<=-0
        max_lead_gap = 250;
    end
    min_lead_gap=min(trajectories_lf(l).lead_s_nett(1:lane_change_initiation,beta));
    if (min_lead_gap)<=-0
        min_lead_gap = 250;
    end
    crit_max_gap = max_lag_gap + max_lead_gap;
    crit_min_gap = min_lag_gap + min_lead_gap;

    lane_change_duration = (lane_change_completion-lane_change_initiation)./10;
    % Check speed_at_merge and relative position of merge location
    speed_at_merge = trajectories(l).v_cal(lane_change_initiation);
    %extend to relative location in future
    location = trajectories(l).x_sm(lane_change_initiation);
    merge_location = (location-x_min)/ramp_length;
    %merge_location = trajectories(l).x_sm(lane_change_completion);
    %Truck_lane_change_data=[Truck_lane_change_data;l,lane_change_duration, lag_gap, speed_at_merge, merge_location];
    Truck_lane_change_data=[Truck_lane_change_data;l,lane_change_duration, lag_gap, min_lag_gap, max_lag_gap, lead_gap, min_lead_gap, max_lead_gap, speed_at_merge, merge_location];

    plot(trajectories(l).y_sm);
    hold on;
    line([lane_change_initiation lane_change_initiation],[-3 3]);
    hold on;
    line([lane_change_completion lane_change_completion],[-3 3]);
    hold on;
    line([pt pt],[-3 3],'Color', 'black');
%     plot(trajectories(l).v_cal);
%     hold on;
%     line([lane_change_initiation lane_change_initiation],[0 120]);
%     %pause();
%      plot(trajectories(l).x_sm,trajectories(l).y_sm);
%      hold on;
%     plot(trajectories(l).v_cal);
%     hold on;
%     line([lane_change_initiation lane_change_initiation],[0 120]);
    k
end