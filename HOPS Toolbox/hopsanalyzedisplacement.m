function displacementVariables = hopsanalyzedisplacement(plane,data,trials,setup,f)

for i = 1:trials%determines an angular position measurement during the sustained head rotation to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        oculusDisplacement = data.oculusTrialDisplacement(:,i);
        qualisysDisplacement = data.qualisysTrialDisplacement(:,i);
        qualisysVelocity = data.qualisysTrialVelocity(:,i);
        [~,maxVelTime] = max(qualisysVelocity);
        [~,minVelTime] = max(-qualisysVelocity);
        
        max2min = minVelTime-maxVelTime;
        trialTime = round(max2min/2)+maxVelTime;
        
        decision = 4;
        while decision~=0&&decision~=1
            if setup==1
                scrsz = get(0,'ScreenSize');
                figure('Position',scrsz);
            else
                set(gcf,'Position',[697 45 1214 964]);
            end
            y1 = [qualisysDisplacement(trialTime)+2,qualisysDisplacement(trialTime)+12];%y needs to be below the value at the timestamp
            my1 = [qualisysDisplacement(trialTime)+3,qualisysDisplacement(trialTime)+3];%y needs to be below the value at the timestamp
            x1 = [(trialTime/75),(trialTime/75)];
            Xaxes = ((1:f)/75);
            plot(Xaxes,oculusDisplacement(1:f),'b','linewidth',2);
            hold on
            plot(Xaxes,qualisysDisplacement(1:f),'r','linewidth',2);
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-1,my1(1,1)+13,'Measurement','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
            ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            Legend = {'Oculus','Qualisys'};
            legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            legend('boxoff');
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
                oculusTrialAngle(i,:) = oculusDisplacement(trialTime,:); %#ok<*AGROW>
                qualisysTrialAngle(i,:) = qualisysDisplacement(trialTime,:);
            elseif decision==0
                oculusTrialAngle(i,:) = nan;
                qualisysTrialAngle(i,:) = nan;
            else
                decision = 4;
            end
        end
        clearvars -except setup plane data trials oculusTrialAngle qualisysTrialAngle trialInfo f
        clc
    elseif TF(1,1)==1
        oculusTrialAngle(i,:) = nan; %#ok<*AGROW>
        qualisysTrialAngle(i,:) = nan;
    end
end

displacementVariables = [oculusTrialAngle,qualisysTrialAngle,oculusTrialAngle-qualisysTrialAngle,(oculusTrialAngle+qualisysTrialAngle)/2,oculusTrialAngle./qualisysTrialAngle];