function [syncedOculusTrial,syncedQualisysTrial] = hopstrialsync(oculusDisplacement,qualisysDisplacement,f,S,trial,setup)
%f = frames per trial
%S = start of oculus sync
%detemine the peaks in each of the data sets to use an 'event' to
%synchronize each trial
%this is necessary due to the variable sampling of the Oculus Rift
%choose time points that relate to the same event
%the two time series should appear to be line up or be on top of each other
%if the correct time points are chosen
%if the synchronization is off, the program allows the user to choose again
v = f-1;
oculusVelocity = diff(oculusDisplacement)*75;

max1 = max(oculusVelocity(S:end));
max1 = .75*max1;%set velocity threshold criterion at 75% of peak velocity

Peaks1 = 0;
PeakSize1 = [];
E = length(oculusVelocity);
T = E-2;
S = S+1;

for N = S:T;%runs through the data and finds peaks that are above the criterion value in oculus data
    if oculusVelocity(N-1)<oculusVelocity(N) && oculusVelocity(N+1)<oculusVelocity(N)&& oculusVelocity(N)>max1;
        Peaks1 = Peaks1+1;
        PeakPlace1(Peaks1) = N; %#ok<*AGROW>
        PeakSize1 = vertcat(PeakSize1,oculusVelocity(N));
    end
end

qualisysVelocity = diff(qualisysDisplacement)*75;

max2 = max(qualisysVelocity);
max2 = .75*max2;%set velocity threshold criterion at 75% of peak velocity

Peaks2 = 0;
PeakSize2 = [];
E = length(qualisysVelocity);
T = E-2;

for N = 2:T;%runs through the data and finds peaks that are above the criterion value in oculus data
    if qualisysVelocity(N-1)<qualisysVelocity(N) && qualisysVelocity(N+1)<qualisysVelocity(N)&& qualisysVelocity(N)>max2;
        Peaks2 = Peaks2+1;
        PeakPlace2(Peaks2) = N;
        PeakSize2 = vertcat(PeakSize2,qualisysVelocity(N));
    end
end

a = gt(Peaks1,Peaks2);%compares # of peaks found in each timeseries

if a==1%determines total peaks found as the largest # of peaks found in either time series
    totalPeaks = Peaks1;
else
    totalPeaks = Peaks2;
end

decision = 0;
while decision==0
    if setup==1
        scrsz = get(0,'ScreenSize');
        figure('Position',scrsz);
    else
        set(gcf,'Position',[697 45 1214 964]);
    end
    t = v/75;
    axis([0 t -200 200]);
    Xaxes = ((1:v)/75);
    y1 = [-100,200];%if necessary change axis limits to ensure all data is visible
    plot(Xaxes,oculusVelocity(1:v),'b','linewidth',2);
    hold on
    plot(Xaxes,qualisysVelocity(1:v),'r','linewidth',2);
    Legend = {'Oculus','Qualisys'};
    legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
    legend('boxoff');
    yLabel = strcat('Velocity (', sprintf('%c', char(176)),'s^{-1})');
    ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
    xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
    title(strcat('Trial',{' '},num2str(trial),' - Synchronize trial using velocity'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
    set(gca,'fontsize',22,'fontname','Gill Sans MT')
    set(gca,'Ticklength',[0,0]);
    box('off')
    axis square
    
    for i = 1:Peaks1;%plots vertical lines on top of time series data to view time points that can be used for synchronization
        x2 = PeakPlace1(:,i);
        x1 = [(x2/75),(x2/75)];
        plot(x1,y1,'b-.','LineWidth',2);%time points from oculus data
        hold on
    end
    
    for i = 1:Peaks2;
        x2 = PeakPlace2(:,i);
        x1 = [(x2/75),(x2/75)];
        plot(x1,y1,'r:','LineWidth',2);%time points from qualisys data
        hold on
    end
    
    AllPeaks = {'Number','Oculus','Qualisys'};
    AllPeaks(2:totalPeaks+1,1) = num2cell(1:totalPeaks);
    AllPeaks(2:Peaks1+1,2) = num2cell(PeakPlace1');
    AllPeaks(2:Peaks2+1,3) = num2cell(PeakPlace2');
    
    display(AllPeaks)%displays time of peaks so user can choose times from each time series for synchronization
    
    Question1 = input('Which sync time to use for Oculus data? (Hit enter if timeseries are synced)\n');
    Question2 = input('Which sync time to use for Qualisys data? (Hit enter if timeseries are synced)\n');
    
    if Question1==0
        display('You entered zero?');
        pause
        close all%NOT SURE WHAT I'VE DONE HERE
        currentTrialQualisys = nan(f,1); %#ok<*NASGU>
        currentTrialOculus = nan(f,1);
    elseif isempty(Question1)&&isempty(Question2)%NOT SURE WHAT I'VE DONE HERE
        currentTrialOculus = oculusDisplacement;
        currentTrialQualisys = qualisysDisplacement;
        decision = 1;
        close all
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        Xaxes = ((1:f)/75);
        plot(Xaxes,currentTrialOculus(1:f),'b','linewidth',2);
        hold on
        plot(Xaxes,currentTrialQualisys(1:f),'r','linewidth',2);
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
        xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
        Legend = {'Oculus','Qualisys'};
        legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
        legend('boxoff');
        title(strcat('Trial',{' '},num2str(trial),' - Trial synchronized with Velocity'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
        set(gca,'fontsize',22,'fontname','Gill Sans MT')
        set(gca,'Ticklength',[0,0]);
        box('off')
        t = f/75;
        axis([0 t -40 100]);
        axis square
        
        decision = input('(1)Accept sync\n(0)Reject sync\n(5)Data will not sync properly, reject outright\n');%accepts or rejects synchronization based on user input
        
        if decision==1%accepts current synchronization
            syncedOculusTrial = currentTrialOculus;
            syncedQualisysTrial = currentTrialQualisys;
        elseif decision==5
            syncedOculusTrial = nan(f,1);%sets data to NANs
            syncedQualisysTrial = nan(f,1);
        else%rejects current synchrnonization and reruns the velocity synchronization procedure
            decision = 0;
        end
        close all
    elseif isempty(Question1)||isempty(Question2)%NOT SURE WHAT I'VE DONE HERE
        decision = 0;
        close all
    elseif Question1>length(PeakPlace1)||Question2>length(PeakPlace2)%NOT SURE WHAT I'VE DONE HERE
        decision = 0;
        close all
    else%NOT SURE WHAT I'VE DONE HERE
        close all
        syncOculusTime = PeakPlace1(1,Question1);
        syncQualisysTime = PeakPlace2(1,Question2);
        
        timediff = abs(syncQualisysTime-syncOculusTime);%calculate the offset between the two time series
        
        if timediff==0%synchronizes the data using the offset derived from the velocity profiles
            qualisysSync = qualisysDisplacement;
            oculusSync = oculusDisplacement;
        elseif syncQualisysTime>syncOculusTime
            qualisysSync = qualisysDisplacement(timediff:end);
            oculusSync = oculusDisplacement(1:end-timediff);
        else
            qualisysSync = qualisysDisplacement(1:end-timediff);
            oculusSync = oculusDisplacement(timediff:end);
        end
        
        currentTrialQualisys = vertcat(qualisysSync,nan(f-length(qualisysSync),1));%updates the length of the trial to standard trial length (in frames)
        currentTrialOculus = vertcat(oculusSync,nan(f-length(oculusSync),1));
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        Xaxes = ((1:f)/75);
        plot(Xaxes,currentTrialOculus(1:f),'b','linewidth',2);
        hold on
        plot(Xaxes,currentTrialQualisys(1:f),'r','linewidth',2);
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
        xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
        Legend = {'Oculus','Qualisys'};
        legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
        legend('boxoff');
        title(strcat('Trial',{' '},num2str(trial),' - Trial synchronized with Velocity'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
        set(gca,'fontsize',22,'fontname','Gill Sans MT')
        set(gca,'Ticklength',[0,0]);
        box('off')
        t = f/75;
        axis([0 t -40 100]);
        axis square
        
        decision = input('(1)Accept sync\n(0)Reject sync\n(5)Data will not sync properly, reject outright\n');%accepts or rejects synchronization based on user input
        
        if decision==1%accepts current synchronization
            syncedOculusTrial = currentTrialOculus;
            syncedQualisysTrial = currentTrialQualisys;
        elseif decision==5%rejects current synchrnonization and reruns the velocity synchronization procedure
            syncedOculusTrial = nan(f,1);%sets data to NANs
            syncedQualisysTrial = nan(f,1);
        else%rejects current synchrnonization and reruns the velocity synchronization procedure
            decision = 0;
        end
        close all
    end
    clc
end