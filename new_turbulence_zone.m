%========================================================================
% Created on Mon April 29 09:06:00 2019
% Topic: Find turbulence zone for trucks, cars, and vans
% Dataset: Helicopter trjectory data from Aries van Beinum 
% @author: salilsharma

% A. van Beinum et al. "Driving behaviour at motorway ramps and weaving 
% segments based on empirical trajectory data". In: Transportation Research
% Part C: Emerging Technologies 92 (2018), pp. 426-441.
%========================================================================

clear; clc;

%Load a bootleneck section
site='weaving_Ridderkerk_south';
filename=strcat(site,'_trajectories.mat');
load(filename);

%Load leader-follower data
load(strcat(site,'_leader_follower.mat'));

%Load site characteristics file
load(strcat(site,'_lanes.mat'));
x_min = lanes.x_min;
x_max = x_min + lanes.ramp_length;

merge=[];
diverge=[];

%Filter trucks
ids=find([trajectories.l]>0)';
for j=1:length(ids)
    i=ids(j);
    %store lanes vector as lanetraj
    lanetraj=[];
    lanetraj=trajectories(i).lanes;
    
    if lanetraj(1) == -1 && lanetraj(end)~= -1
        p = ischange(lanetraj);
        loc = find (p == 1);
        xpos = trajectories(i).x_sm(loc(1)) - x_min;
        merge = [merge;i,trajectories(i).l, xpos];
        
    elseif lanetraj(1) ~= -1 && lanetraj(end)== -1
        p = ischange(lanetraj);
        loc = find (p == 1);
        xpos = trajectories(i).x_sm(loc(end)) - x_min;
        diverge = [diverge;i,trajectories(i).l, xpos];
    else
        continue;
    end
end

%histogram(id(:,3), 'BinWidth',25)
