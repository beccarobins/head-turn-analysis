function accelerationVariables = hopsanalyzeacceleration(plane,data,trials,setup,a)

for i = 1:trials%determines the peak acceleration TOWARDS the target amplitude to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        
        oculusAcceleration = data.oculusTrialAcceleration(:,i);
        qualisysAcceleration = data.qualisysTrialAcceleration(:,i);
        
        [~,maxAccTime] = max(qualisysAcceleration(1:525));%finds peak Acc during first half of trial
        
        decision = 4;
        while decision~=0&&decision~=1
            if setup==1
                scrsz = get(0,'ScreenSize');
                figure('Position',scrsz);
            else
                set(gcf,'Position',[697 45 1214 964]);
            end
            y1 = [qualisysAcceleration(maxAccTime)+2,qualisysAcceleration(maxAccTime)+50];%y needs to be below the value at the timestamp
            my1 = [qualisysAcceleration(maxAccTime)+3,qualisysAcceleration(maxAccTime)+3];%y needs to be below the value at the timestamp
            x1 = [(maxAccTime/75),(maxAccTime/75)];
            Xaxes = ((1:a)/75);
            plot(Xaxes,oculusAcceleration(1:a),'b','linewidth',2);
            hold on
            plot(Xaxes,qualisysAcceleration(1:a),'r','linewidth',2);
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-1,my1(1,1)+100,'Peak Acceleration','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            yLabel = strcat('Acceleration (', sprintf('%c', char(176)),'s^{-2})');
            ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            Legend = {'Oculus','Qualisys'};
            legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            legend('boxoff');
            title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Acceleration TO Target'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            set(gca,'fontsize',22)
            set(gca,'Ticklength',[0,0]);
            box('off')
            t = a/75;
            axis([0 t -500 1000]);
            axis square
            
            decision = input('(1)Keep data\n(0)Exclude data\n');
            close all
            
            if decision==1
                oculusTrialPeakAcc(i,:) = oculusAcceleration(maxAccTime,:); %#ok<*AGROW>
                qualisysTrialPeakAcc(i,:) = qualisysAcceleration(maxAccTime,:);
            elseif decision==0
                oculusTrialPeakAcc(i,:)  = nan;
                qualisysTrialPeakAcc(i,:)  = nan;
            else
                decision = 4;
            end
        end
    elseif TF(1,1)==1
        oculusTrialPeakAcc(i,:) = nan; %#ok<*AGROW>
        qualisysTrialPeakAcc(i,:) = nan;
    end
    clearvars -except setup plane data trials oculusTrialPeakAcc qualisysTrialPeakAcc a
    clc
end

accelerationTOvariables = [oculusTrialPeakAcc,qualisysTrialPeakAcc,oculusTrialPeakAcc-qualisysTrialPeakAcc,(oculusTrialPeakAcc+qualisysTrialPeakAcc)/2];

for i = 1:trials%determines the peak acceleration AWAY FROM the target amplitude to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        oculusAcceleration = -data.oculusTrialAcceleration(:,i);
        qualisysAcceleration = -data.qualisysTrialAcceleration(:,i);
        
        [~,maxAccTime] = max(qualisysAcceleration(526:end));%finds peak Acc during last half of trial
        maxAccTime = maxAccTime+525;%corrects for maxAccTime by adding first half frame #
        
        decision = 4;
        while decision~=0&&decision~=1
            if setup==1
                scrsz = get(0,'ScreenSize');
                figure('Position',scrsz);
            else
                set(gcf,'Position',[697 45 1214 964]);
            end
            y1 = [qualisysAcceleration(maxAccTime)+2,qualisysAcceleration(maxAccTime)+50];%y needs to be below the value at the timestamp
            my1 = [qualisysAcceleration(maxAccTime)+3,qualisysAcceleration(maxAccTime)+3];%y needs to be below the value at the timestamp
            x1 = [(maxAccTime/75),(maxAccTime/75)];
            Xaxes = ((1:a)/75);
            plot(Xaxes,oculusAcceleration(1:a),'b','linewidth',2);
            hold on
            plot(Xaxes,qualisysAcceleration(1:a),'r','linewidth',2);
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-1,my1(1,1)+100,'Peak Acceleration','fontsize',18,'fontweight','bold','fontname','Gill Sans MT');
            yLabel = strcat('Acceleration (', sprintf('%c', char(176)),'s^{-2})');
            ylabel(yLabel,'fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            xlabel('Time (s)','fontsize',22,'fontweight','bold','fontname','Gill Sans MT')
            Legend = {'Oculus','Qualisys'};
            legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            legend('boxoff');
            title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Acceleration FROM Target'),'fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
            set(gca,'fontsize',22)
            set(gca,'Ticklength',[0,0]);
            box('off')
            t = a/75;
            axis([0 t -500 1000]);
            axis square
            
            decision = input('(1)Keep data\n(0)Exclude data\n');
            close all
            
            if decision==1
                oculusTrialPeakAcc(i,:) = oculusAcceleration(maxAccTime,:); %#ok<*AGROW>
                qualisysTrialPeakAcc(i,:) = qualisysAcceleration(maxAccTime,:);
            elseif decision==0
                oculusTrialPeakAcc(i,:)  = nan;
                qualisysTrialPeakAcc(i,:)  = nan;
            else
                decision = 4;
            end
        end
    elseif TF(1,1)==1
        oculusTrialPeakAcc(i,:) = nan; %#ok<*AGROW>
        qualisysTrialPeakAcc(i,:) = nan;
    end
    clearvars -except setup plane data trials oculusTrialPeakAcc qualisysTrialPeakAcc accelerationTOvariables a
    clc
end

accelerationFROMvariables = [oculusTrialPeakAcc,qualisysTrialPeakAcc,oculusTrialPeakAcc-qualisysTrialPeakAcc,(oculusTrialPeakAcc+qualisysTrialPeakAcc)/2];

accelerationVariables = [accelerationTOvariables,accelerationFROMvariables];