%========================================================================
% Created on Fri Feb 01 18:41:00 2019
% Topic: Find position where trucks perform MLC
% Dataset: Helicopter trjectory data from Aries van Beinum 
% @author: salilsharma

% A. van Beinum et al. "Driving behaviour at motorway ramps and weaving 
% segments based on empirical trajectory data". In: Transportation Research
% Part C: Emerging Technologies 92 (2018), pp. 426-441.
%========================================================================

clear; clc;

%Load a bootleneck section
site='offramp_Zonzeel_south';
filename=strcat(site,'_trajectories.mat');
load(filename);

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
    if lanetraj(1) == -1 
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

%% Produce plots of trajecotry wrt time
%un=[];
% counter=[counter1;counter2];
% for k=1:length(counter)
%     figure(1); hold on;
%     l=counter(k); 
%     %unique(trajectories(l).lanes);
%     %un=[un;length(unique(trajectories(l).lanes))];
%     plot(trajectories(l).lanes);
% end

%% Produce plots of trajectories wrt space
counter=counter2;
xpos=[];
mlcxpos=[];
un=[];
for k=1:length(counter)
    figure(1); hold on;
    l=counter(k);
    changelanepoint=find(ischange(trajectories(l).lanes,1));
    pos=trajectories(l).x_sm;
    speed_at_pos=trajectories(l).v_cal;
    [peaks,idx]=findpeaks(trajectories(l).y_sm);
    xpos=[xpos;pos(changelanepoint)];
    if trajectories(l).lanes(changelanepoint) ~= 2  
        mlcxpos=[mlcxpos;pos(changelanepoint),speed_at_pos(changelanepoint)];
    end
    unique(trajectories(l).lanes);
    un=[un;length(unique(trajectories(l).lanes))];
    plot(trajectories(l).x_sm,trajectories(l).lanes);
    xlabel('Logitudinal position');
    ylabel('Lanes');
    saveas(gcf,strcat(site,'.fig'));
end
figure(2);histogram(xpos); 
xlabel('Longitudinal position');
ylabel('Count');

%hold 'on'

%saveas(gcf,strcat(site,'_hist.fig'));

%% Produce lane change duration
%figure(3);
%cdfplot(xpos);

%figure(4);
%cdfplot(mlcxpos);