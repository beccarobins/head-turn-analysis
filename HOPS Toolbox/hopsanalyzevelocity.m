function velocityVariables = hopsanalyzevelocity(plane,data,trials,setup,v)

for i = 1:trials%determines the peak velocity TOWARDS the target amplitude to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        
        oculusVelocity = data.oculusTrialVelocity(:,i);
        qualisysVelocity = data.qualisysTrialVelocity(:,i);
        
        [~,maxVelTime] = max(qualisysVelocity(1:525));
        
        decision = 4;
        while decision~=0&&decision~=1
            if setup==1
                scrsz = get(0,'ScreenSize');
                figure('Position',scrsz);
            else
                set(gcf,'Position',[697 45 1214 964]);
            end
            y1 = [qualisysVelocity(maxVelTime)+2,qualisysVelocity(maxVelTime)+30];%y needs to be below the value at the timestamp
            my1 = [qualisysVelocity(maxVelTime)+3,qualisysVelocity(maxVelTime)+3];%y needs to be below the value at the timestamp
            x1 = [(maxVelTime/75),(maxVelTime/75)];
            Xaxes = ((1:v)/75);
            plot(Xaxes,oculusVelocity(1:v),'b','linewidth',2);
            hold on
            plot(Xaxes,qualisysVelocity(1:v),'r','linewidth',2);
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-1,my1(1,1)+40,'Peak Velocity','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            yLabel = strcat('Velocity (', sprintf('%c', char(176)),'s^{-1})');
            ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            Legend = {'Oculus','Qualisys'};
            legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            legend('boxoff');
            title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Velocity TO Target'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            set(gca,'fontsize',22)
             set(gca,'Ticklength',[0,0]);
            box('off')
            t = v/75;
            axis([0 t -200 200]);
            axis square
            
            decision = input('(1)Keep data\n(0)Exclude data\n');
            close all
            
            if decision==1
                oculusTrialPeakVel(i,:) = oculusVelocity(maxVelTime,:); %#ok<*AGROW>
                qualisysTrialPeakVel(i,:) = qualisysVelocity(maxVelTime,:);
            elseif decision==0
                oculusTrialPeakVel(i,:)  = nan;
                qualisysTrialPeakVel(i,:)  = nan;
            else
                decision = 4;
            end
        end
    elseif TF(1,1)==1
        oculusTrialPeakVel(i,:) = nan; %#ok<*AGROW>
        qualisysTrialPeakVel(i,:) = nan;
    end
    clearvars -except setup plane data trials oculusTrialPeakVel qualisysTrialPeakVel v
    clc
end

velocityTOvariables = [oculusTrialPeakVel,qualisysTrialPeakVel,oculusTrialPeakVel-qualisysTrialPeakVel,(oculusTrialPeakVel+qualisysTrialPeakVel)/2];

for i = 1:trials%determines the peak velocity AWAY FROM the target amplitude to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        
        oculusVelocity = -data.oculusTrialVelocity(:,i);
        qualisysVelocity = -data.qualisysTrialVelocity(:,i);
        
        [~,maxVelTime] = max(qualisysVelocity(526:end));
        maxVelTime = maxVelTime+525;
        
        decision = 4;
        while decision~=0&&decision~=1
            if setup==1
                scrsz = get(0,'ScreenSize');
                figure('Position',scrsz);
            else
                set(gcf,'Position',[697 45 1214 964]);
            end
            y1 = [qualisysVelocity(maxVelTime)+2,qualisysVelocity(maxVelTime)+30];%y needs to be below the value at the timestamp
            my1 = [qualisysVelocity(maxVelTime)+3,qualisysVelocity(maxVelTime)+3];%y needs to be below the value at the timestamp
            x1 = [(maxVelTime/75),(maxVelTime/75)];
            Xaxes = ((1:v)/75);
            plot(Xaxes,oculusVelocity(1:v),'b','linewidth',1.5);
            hold on
            plot(Xaxes,qualisysVelocity(1:v),'r','linewidth',1.5);
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-1,my1(1,1)+40,'Peak Velocity','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            yLabel = strcat('Velocity (', sprintf('%c', char(176)),'s^{-1})');
            ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            Legend = {'Oculus','Qualisys'};
            legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            legend('boxoff');
            title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Velocity FROM Target'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            set(gca,'fontsize',22)
            set(gca,'Ticklength',[0,0]);
            box('off')
            t = v/75;
            axis([0 t -200 200]);
            axis square
            
            decision = input('(1)Keep data\n(0)Exclude data\n');
            close all
            
            if decision==1
                oculusTrialPeakVel(i,:) = oculusVelocity(maxVelTime,:); %#ok<*AGROW>
                qualisysTrialPeakVel(i,:) = qualisysVelocity(maxVelTime,:);
            elseif decision==0
                oculusTrialPeakVel(i,:)  = nan;
                qualisysTrialPeakVel(i,:)  = nan;
            else
                decision = 4;
            end
        end
    elseif TF(1,1)==1
        oculusTrialPeakVel(i,:) = nan; %#ok<*AGROW>
        qualisysTrialPeakVel(i,:) = nan;
    end
    
    clearvars -except setup plane data trials oculusTrialPeakVel qualisysTrialPeakVel velocityTOvariables v
    clc
end

velocityFROMvariables = [oculusTrialPeakVel,qualisysTrialPeakVel,oculusTrialPeakVel-qualisysTrialPeakVel,(oculusTrialPeakVel+qualisysTrialPeakVel)/2];

velocityVariables = [velocityTOvariables,velocityFROMvariables];