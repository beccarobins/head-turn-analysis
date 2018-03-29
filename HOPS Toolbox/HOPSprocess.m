function trialData = HOPSprocess(plane,oculusData,qualisysData,trials,f,oculusMarks,setup,trialAngle)
%f = frames per trial;
oculusSessionData = vertcat(oculusData,nan((f*trials)-length(oculusData),1));
qualisysSessionData = vertcat(qualisysData,nan((f*trials)-length(qualisysData),1));
oculusTrialsRaw = nan(f,trials);
oculusTrials = nan(f,trials);
qualisysTrials = nan(f,trials);
study = strsplit(pwd,'\');%subject name generated from folder
study = char(study(:,end-1));
 ST = strcmp(study,'Pilot Validation and Joint Position Matching Data');

 for i = 1:trials
       
    if ST==1
        if oculusMarks(i,:)>0%flips session data so that trial is positive
            oculusTrialsRaw(:,i) = -oculusSessionData(1:f);
            qualisysTrials(:,i) = -qualisysSessionData(1:f);
        else
            oculusTrialsRaw(:,i) = oculusSessionData(1:f);
            qualisysTrials(:,i) = qualisysSessionData(1:f);
        end
    else
        if oculusMarks(i,:)>0%flips session data so that trial is positive
            oculusTrialsRaw(:,i) = oculusSessionData(1:f);
            qualisysTrials(:,i) = qualisysSessionData(1:f);
        else
            oculusTrialsRaw(:,i) = -oculusSessionData(1:f);
            qualisysTrials(:,i) = -qualisysSessionData(1:f);
        end
    end
    
    qualisysTrials(:,i) = qualisysTrials(:,i)-qualisysTrials(1,i);
    oculusSessionData(1:f) = [];
    qualisysSessionData(1:f) = [];
    question = 0;
    lastTime = 0;
    while question == 0;
        lastTime = lastTime+25;
        oculusVelTrials(:,i) = diff(oculusTrialsRaw(:,i))*75; %#ok<*AGROW>
        oculusAccTrials(:,i) = diff(oculusVelTrials(:,i))*75;
        currentAcc = oculusAccTrials(:,i);
        times = 0;
        
        for N = 2:lastTime
            if currentAcc(N)<-100||currentAcc(N)>100
                times = times+1;
                zeroTime(times) = N;
            end
        end
        
        TF = exist('zeroTime','var');
        
        if TF==0
            zeroTime = 1;%offset for recalibration
        else
            zeroTime = max(zeroTime);
        end
        
        oculusTrials(:,i) = oculusTrialsRaw(:,i)-oculusTrialsRaw(zeroTime,i);%zeros out trial data
        qualisysTrials(:,i) = qualisysTrials(:,i)-qualisysTrials(zeroTime,i);
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        Xaxes = ((1:f)/75);
        y1 = [oculusTrials(zeroTime(1,1),i)-10,oculusTrials(zeroTime(1,1),i)-3];%y needs to be below the value at the timestamp
        x1 = [(zeroTime(1,1)/75),(zeroTime(1,1)/75)];
        my1 = [oculusTrials(zeroTime(1,1),i)-3,oculusTrials(zeroTime(1,1),i)-3];%y needs to be below the value at the timestamp
        trialAngleLine(1:f) = abs(trialAngle(i,:));
        plot(Xaxes,oculusTrials((1:f),i),'b','linewidth',2);
        hold on
        plot(Xaxes,qualisysTrials((1:f),i),'r','linewidth',2);
        plot(trialAngleLine,'k','linewidth',2);
        plot(x1,y1,'k','linewidth',2);
        plot(x1,my1,'^k','MarkerSize',10,'MarkerFaceColor','k');
        text((oculusTrials(zeroTime(1,1),i)/75),oculusTrials(zeroTime(1,1),i)-12,'Recalibration','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
        xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
        Legend = {'Oculus','Qualisys'};
        legend(Legend,'Location','NorthEast','fontsize',22,'fontname','Gill Sans MT');
        legend('boxoff');
        title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Remove offset'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
        set(gca,'fontsize',22,'fontname','Gill Sans MT')
        set(gca,'Ticklength',[0,0]);
        box('off');
        t = f/75;
        axis([0 t -40 100]);
        axis square
        
        question = input('Is the data zeroed correctly?\n(1)Yes\n(0)No\n(2)start zero process over\n(5)Data will not calibrate correctly, remove from further analysis\n');
        close all
        Start(:,i) = zeroTime;
        clc
        
        if question==1
            [oculusTrials(:,i),qualisysTrials(:,i)] = hopstrialsync(oculusTrials(:,i),qualisysTrials(:,i),f,Start(:,i),i,setup);%begins trial sync
        elseif question==0
            oculusTrials(:,i) = nan(f,1);%moves to the next recalibration point
            question = 0;
            clearvars -except trialAngle setup plane qualisysTrials oculusTrials oculusMarks i lastTime trials f question oculusTrialsRaw oculusSessionData qualisysSessionData ST
        elseif question==2
            oculusTrials(:,i) = nan(f,1);%resets oculus data if processing is restarted
            lastTime = 0;%qualisys data is not reset because the oculus data is beging changed to 'fit' qualisys data
            question = 0;
            clearvars -except trialAngle setup plane qualisysTrials oculusTrials oculusMarks i lastTime trials f question oculusTrialsRaw oculusSessionData qualisysSessionData ST
        elseif question==5
            oculusTrials(:,i) = nan(f,1);%sets data to NANs
            qualisysTrials(:,i) = nan(f,1);
            clearvars -except trialAngle setup plane qualisysTrials oculusTrials oculusMarks i lastTime trials f question oculusTrialsRaw oculusSessionData qualisysSessionData ST
        else%resets data in case none of the presented options are chosen
            oculusTrials(:,i) = nan(f,1);%resets oculus data if processing is restarted
            lastTime = 0;%qualisys data is not reset because the oculus data is beging changed to 'fit' qualisys data
            question = 0;
            clearvars -except trialAngle setup plane qualisysTrials oculusTrials oculusMarks i lastTime trials f question oculusTrialsRaw oculusSessionData qualisysSessionData ST
        end
    end
end

oculusTrialDisplacement = oculusTrials;
oculusTrialVelocity = nan(f-1,trials);
oculusTrialAcceleration = nan(f-2,trials);

qualisysTrialDisplacement = qualisysTrials;
qualisysTrialVelocity = nan(f-1,trials);
qualisysTrialAcceleration = nan(f-2,trials);

for i = 1:trials
    oculusTrialVelocity(:,i) = diff(oculusTrialDisplacement(:,i))*75;
    oculusTrialAcceleration(:,i) = diff(oculusTrialVelocity(:,i))*75;
    qualisysTrialVelocity(:,i) = diff(qualisysTrialDisplacement(:,i))*75;
    qualisysTrialAcceleration(:,i) = diff(qualisysTrialVelocity(:,i))*75;
end

trialData = v2struct(oculusTrialDisplacement,oculusTrialVelocity,oculusTrialAcceleration,qualisysTrialDisplacement,qualisysTrialVelocity,qualisysTrialAcceleration);

clc