function HOPSoutputVariables = HOPSanalyzeJPM(plane,data,trials,trialInfo,setup,f);

%data is all timeseries data (qualisys data
%Determine trial angle and match angle
for i = 1:trials
    
    TF = isnan(data.qualisysTrialDisplacement(:,i));
    
    if TF(1,1)==0
        displacement = data.qualisysTrialDisplacement(:,i);
        oculusDisplacement = data.oculusTrialDisplacement(:,i);
        h = f/2;
        positionDisplacement = displacement(1:h);
        matchDisplacement = displacement(h+1:end);
        positionVelocity = diff(positionDisplacement)*75;
        matchVelocity = diff(matchDisplacement)*75;
        
        [~,maxVelTime] = max(positionVelocity);
        [~,minVelTime] = min(positionVelocity);
        
        max2min = minVelTime-maxVelTime;
        positionTime = round(max2min/2)+maxVelTime;
        
        [~,maxVelTime] = max(matchVelocity);
        [~,minVelTime] = min(matchVelocity);
        
        max2min = minVelTime-maxVelTime;
        matchTime = (round(max2min/2)+maxVelTime)+h;
        
        decision = 4;
        while decision~=0&&decision~=1
            if setup==1
                scrsz = get(0,'ScreenSize');
                figure('Position',scrsz);
            else
                set(gcf,'Position',[697 45 1214 964]);
            end
            y1 = [displacement(positionTime)+2,displacement(positionTime)+12];%y needs to be below the value at the timestamp
            my1 = [displacement(positionTime)+3,displacement(positionTime)+3];%y needs to be below the value at the timestamp
            x1 = [(positionTime/75),(positionTime/75)];
            y2 = [displacement(matchTime)+2,displacement(matchTime)+12];%y needs to be below the value at the timestamp
            my2 = [displacement(matchTime)+3,displacement(matchTime)+3];%y needs to be below the value at the timestamp
            x2 = [(matchTime/75),(matchTime/75)];
            Xaxes = ((1:f)/75);
            plot(Xaxes,oculusDisplacement(1:f),'b','linewidth',2);
            hold on
            plot(Xaxes,displacement(1:f),'r','linewidth',2);
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-4,my1(1,1)+13,'Position Measurement','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            plot(x2,y2,'k','linewidth',2);
            plot(x2,my2,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x2(1,1)-4,my2(1,1)+13,'Match Measurement','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
            ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            %Legend = {'Oculus','Qualisys'};
            %legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            %legend('boxoff');
            title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Measurement for Position Analysis'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            set(gca,'fontsize',22,'fontname','Gill Sans MT')
            set(gca,'Ticklength',[0,0]);
            box('off')
            t = f/75;
            axis([0 t -20 100]);
            axis square
            
            decision = input('(1)Keep data\n(0)Exclude data\n');
            close all
            
            if decision==1
                positionAngle(i,:) = displacement(positionTime,:);
                matchAngle(i,:) = displacement(matchTime,:);
                oculusPositionAngle(i,:) = oculusDisplacement(positionTime,:);
                oculusMatchAngle(i,:) = oculusDisplacement(matchTime,:);
            elseif decision==0
                positionAngle(i,:) = nan;
                matchAngle(i,:) = nan;
                oculusPositionAngle(i,:) = nan;
                oculusMatchAngle(i,:) = nan;
            else
                decision = 4;
            end
        end
        clearvars -except setup plane data trials positionAngle matchAngle trialInfo f oculusPositionAngle oculusMatchAngle
        clc
    elseif TF(1,1)==1
        positionAngle(i,:) = nan;
        matchAngle(i,:) = nan;
        oculusPositionAngle(i,:) = nan;
        oculusMatchAngle(i,:) = nan;
    end
    clearvars -except setup plane data trials positionAngle matchAngle trialInfo f oculusPositionAngle oculusMatchAngle
end
qualisysTrialAngle = positionAngle;%only position angle is used in validity analysis due to the lack of visual target in match trials
oculusTrialAngle = oculusPositionAngle;%changes in angle will affect the average of the system differences/means

HOPSoutputVariables.JPM = sortrows([trialInfo,positionAngle,matchAngle,matchAngle-positionAngle,abs(matchAngle-positionAngle)]);
HOPSoutputVariables.validity = sortrows([trialInfo,oculusTrialAngle,qualisysTrialAngle,oculusTrialAngle-qualisysTrialAngle,(oculusTrialAngle+qualisysTrialAngle)/2,oculusTrialAngle./qualisysTrialAngle]);