function syncData = syncOculusQualisys(subject,plane,oculusData,qualisysData,oculusTime,oculusStart)

qualisysData = qualisysData(1:1.3333:end);%subsample Qualisys data from 100Hz to 75Hz
qualisysData = qualisysData-qualisysData(1,1);%zeros out the Qualisys dataset
oculusData = oculusData - oculusData(1,1);%zeros out the Oculus dataset

startOculus = find(oculusData>15);%finds first appearance of criterion amplitude (15) in oculus data
startOculus = startOculus(1,1);
peaks = 0;

for N = startOculus:startOculus+500%searches for position peak in ROM test (Oculus)in the first 500 frames following the appearance of the criterion amplitude
    if oculusData(N)>oculusData(N-1)&&oculusData(N)>oculusData(N+1)
        peaks = peaks+1;%counts the peaks that fit the above criteria
        peakTimes(peaks,:) = N; %#ok<*AGROW>%determine time of peaks that fit criteria
    end
end

for i = 1:peaks
    peakAmps(i,:) = oculusData(peakTimes(i,:));%finds position of data at times of peaks in oculus data
end

[~,maxAmpTime] = max(peakAmps);

maxOculusTime = peakTimes(maxAmpTime,1);%set the time of the peak amplitude at the ROM test time in oculus data

clearvars peaks peakTimes peakAmps maxAmpTime
startQualisys = find(qualisysData>15);%finds first appearance of criterion amplitude (15) in qualisys data
startQualisys = startQualisys(1,1);
peaks = 0;

for N = startQualisys+1:startQualisys+500%searches for position peak in ROM test (Qualisys) in the first 500 frames following the appearance of the criterion amplitude
    if qualisysData(N)>qualisysData(N-1)&&qualisysData(N)>qualisysData(N+1)
        peaks = peaks+1;%counts the peaks that fit the above criteria
        peakTimes(peaks,:) = N;%determine time of peaks that fit criteria
    end
end

for i = 1:peaks
    peakAmps(i,:) = qualisysData(peakTimes(i,:)); %finds position of data at times of peaks in qualisys data
end

[~,maxAmpTime] = max(peakAmps);

maxQualisysTime = peakTimes(maxAmpTime,1);%set the time of the peak amplitude at the ROM test time in qualisys data

if length(qualisysData)>length(oculusData)%compares data lengths and adds NANs to create equal length data
    oculusTemp = vertcat(oculusData,nan(length(qualisysData)-length(oculusData),1));%temporary oculus profile created for plotting purposes
    qualisysTemp = qualisysData;%temporary qualisys profile created for plotting purposes
else
    oculusTemp = oculusData;
    qualisysTemp = vertcat(qualisysData,nan(length(oculusData)-length(qualisysData),1));
end

qualisysSync = qualisysData(maxQualisysTime:end);
oculusSync = oculusData(maxOculusTime:end);
oculusTime = oculusTime(maxOculusTime:end);
qualisysLength = length(qualisysSync);
oculusLength = length(oculusSync);

TF = gt(qualisysLength,oculusLength);

if TF==1
    qualisysData = qualisysSync(1:oculusLength);
    oculusData = oculusSync(1:oculusLength);
    oculusTime = oculusTime(1:oculusLength);
else
    qualisysData = qualisysSync(1:qualisysLength);
    oculusData = oculusSync(1:qualisysLength);
    oculusTime = oculusTime(1:qualisysLength);
end

start = str2double(oculusStart);
start = find(oculusTime>start);

decision = 4;
while decision~=0&&decision~=1
    Xaxes = ((1:length(oculusTemp))/75)';
    scrsz = get(0,'ScreenSize');
    figure('Position',scrsz);
    add1 = 200-qualisysTemp(maxQualisysTime);
    y1 = [qualisysTemp(maxQualisysTime)+10,qualisysTemp(maxQualisysTime)+add1];
    x1 = [(maxQualisysTime/75),(maxQualisysTime/75)];
    my1 = [qualisysTemp(maxQualisysTime)+15,qualisysTemp(maxQualisysTime)+15];
    add2 = 125-oculusTemp(maxOculusTime);
    y2 = [oculusTemp(maxOculusTime)+10,oculusTemp(maxOculusTime)+add2];
    x2 = [(maxOculusTime/75),(maxOculusTime/75)];
    my2 = [oculusTemp(maxOculusTime)+15,oculusTemp(maxOculusTime)+15];
    subplot(3,1,1)
    plot(Xaxes,oculusTemp,'b','linewidth',2)
    hold on
    plot(Xaxes,qualisysTemp,'r','linewidth',2)
    plot(x1,y1,'-k','linewidth',2);
    plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
    text(x1(1,1)-10,y1(1,2)+5,'MAX_Q','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
    plot(x2,y2,'-k','linewidth',2);
    plot(x2,my2,'vk','MarkerSize',10,'MarkerFaceColor','k');
    text(x2(1,1)-10,y2(1,2)+5,'MAX_{Oc}','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
    % Legend = {'Oculus','Qualisys'};
    % legend(Legend,'Location','NorthEast','fontsize',22);
    % legend('boxoff');
    %title(strcat('Raw',{' '},plane,{' '},'Data'),'fontsize',22,'fontweight','bold');
    title(strcat('Raw Data'),'fontsize',30,'fontweight','bold','fontname','Gill Sans MT');
    %yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
    %ylabel(yLabel,'fontsize',35,'fontweight','bold')
    set(gca,'fontsize',35,'fontname','Gill Sans MT')
    set(gca,'Ticklength',[0,0]);
    %yLim = get(gca,'Ylim');
    %text(5,yLim(1,2),'a','fontsize',26,'fontweight','bold');
    box('off')
    
    Xaxes = ((1:length(oculusData))/75)';
    qualisysData = qualisysData-qualisysData(1,1);
    oculusData = oculusData-oculusData(1,1);
    subplot(3,1,2)
    add1 = 125-oculusData(start(1,1));
    plot(Xaxes,qualisysData,'r','linewidth',2)
    hold on
    plot(Xaxes,oculusData,'b','linewidth',2)
    %title(strcat('Oculus and Qualisys',{' '},plane,{' '},'Data Synchronized using ROM'),'fontsize',22,'fontweight','bold');
    title(strcat('Oculus and Qualisys Data Synchronized using ROM'),'fontsize',30,'fontweight','bold','fontname','Gill Sans MT');
    yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
    ylabel(yLabel,'fontsize',35,'fontweight','bold','fontname','Gill Sans MT')
    Legend = {'Oculus','Qualisys'};
    legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
    legend('boxoff');
    set(gca,'Ticklength',[0,0]);
    set(gca,'fontsize',35,'fontname','Gill Sans MT')
    box('off')
    subjectNum = str2num(subject); %#ok<*ST2NM>
    if subjectNum>8%%UNITY PROGRAM WAS CHANGED MID STUDY%%IF DATA IS NOT SYNCING CORRECTLY, MAKE SURE THESE ARE IMPORTED CORRECTLY
        pause
    else
        syncStart = input('How many seconds is the time stamp behind (type 0,1,2, etc.)\n');
        start = syncStart*75;
        if start==0
            start = 1;
        end
    end
    
    y1 = [oculusData(start(1,1))+10,oculusData(start(1,1))+add1-20];%y needs to be below the value at the timestamp
    x1 = [(start(1,1)/75),(start(1,1)/75)];
    my1 = [oculusData(start(1,1))+15,oculusData(start(1,1))+15];
    plot(x1,y1,'-k','linewidth',2);
    plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
    text((oculusData(start(1,1))/75)-50,oculusData(start(1,1))+add1+20,'Timestamp','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
    
    decision = input('Is this the correct timestamp\n(1)Yes\n(0)No\n');
    if decision==1
    elseif decision==0
        decision = 4;
        close all
    end
    clc
end

qualisysData = qualisysData(start:end);
oculusData = oculusData(start:end);
qualisysData = qualisysData-qualisysData(1,1);
oculusData = oculusData-oculusData(1,1);
subplot(3,1,3)
Xaxes = ((1:length(oculusData))/75)';
plot(Xaxes,qualisysData,'r','linewidth',2)
hold on
plot(Xaxes,oculusData,'b','linewidth',2)
%title(strcat(plane,{' '},'Experimental Session, cut using timestamp'),'fontsize',22,'fontweight','bold');
title('Experimental Session, cut using Timestamp','fontsize',30,'fontweight','bold','fontname','Gill Sans MT');
%ylabel(yLabel,'fontsize',35,'fontweight','bold')
xlabel('Time (s)','fontsize',35,'fontweight','bold','fontname','Gill Sans MT')
set(gca,'Ticklength',[0,0]);
set(gca,'fontsize',35,'fontname','Gill Sans MT')
box('off')
%yLim = get(gca,'Ylim');
%text(5,yLim(1,2),'c','fontsize',26,'fontweight','bold');
pause

%%saves a tiff file of the synchrnonization of the data
f=gcf; %f is the handle of the figure you want to export
figpos=getpixelposition(f); %dont need to change anything here
resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
path= pwd; %the folder where you want to put the file

name = char(strcat(subject,{' - '},plane,' - data processing.tiff'));
print(f,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
close all;clc

syncData = v2struct(qualisysData,oculusData);