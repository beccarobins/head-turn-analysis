function blandaltplot(data1,data2,dataTitle,unit)

DATA = sortrows([data1,data2],1);
TF = isnan(DATA);
nanSTART = find(TF>0);

TF = isempty(nanSTART);
if TF==0
DATA = DATA(1:nanSTART-1,:);
end

data1 = DATA(:,1);
data2 = DATA(:,2);

%data1 = oculus dataset
%data2 = qualisys dataset
%dataTitle = the analisys being perform (e.g., displacement for 75 deg
%trials)
TF = strcmp(unit,'displacement');

if TF==1
    yTitle = strcat('Measurement difference',{' ('},sprintf('%c', char(176)),')');
    xTitle = strcat('Measurement mean',{' ('},sprintf('%c', char(176)),')');
    yMax = 5;
    maxX = 90;
else
    TF = strcmp(unit,'velocity');
    if TF==1
        yTitle = strcat('Measurement difference',{' ('},sprintf('%c', char(176)),'s','{^{-1})}');
        xTitle = strcat('Measurement mean',{' ('},sprintf('%c', char(176)),'s','{^{-1})}');
        yMax = 15;
        maxX = 180;
    else
        yTitle = strcat('Measurement difference',{' ('},sprintf('%c', char(176)),'s^{-2})');
        xTitle = strcat('Measurement mean',{' ('},sprintf('%c', char(176)),'s','{^{-2})}');
        yMax = 300;
        maxX = 800;
    end
end

meanData = (data1+data2)/2;
diffData = data1-data2;
N = sum(~isnan(meanData));
maxX = ceil(max(meanData));
minX = floor(min(meanData));
meanLine = minX:maxX;
meanDiff = nanmean(diffData);
meanDiff(1:length(meanLine)) = meanDiff;
SDmeanDiff = nanstd(diffData);
upper95LoA = meanDiff+(SDmeanDiff*1.96);
lower95LoA = meanDiff-(SDmeanDiff*1.96);
test = abs(min(diffData));
test2 = abs(max(diffData));

SEM = nanstd(diffData)/sqrt(N);%Standard Error
ts = tinv([0.025  0.975],N-1);%T-Score
CI = nanmean(diffData) + ts*SEM;
upperCI(1:length(meanLine)) = CI(1,2);
lowerCI(1:length(meanLine)) = CI(1,1);
% if test>test2
%     yMax = ceil(test);
% else
%     yMax = ceil(test2);
% end
r = corr(meanData,diffData);
trendVar = polyfit(meanData,diffData,1);
xDATA = [1:maxX];
trendLine = polyval(trendVar,xDATA);

close all
scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
plot(meanData,diffData,'.','markersize',35);
hold on
plot(meanLine,meanDiff,'k','linewidth',3);
plot(xDATA,trendLine,'r','linewidth',5);
plot(meanLine,upper95LoA,'k--','linewidth',3);
text(maxX,upper95LoA(1,1),'+95%LoA','fontsize',35,'fontweight','bold','fontweight','bold')
plot(meanLine,lower95LoA,'k--','linewidth',3);
text(maxX,lower95LoA(1,1),'-95%LoA','fontsize',35,'fontweight','bold','fontweight','bold')
plot(meanLine,upperCI,'r--','linewidth',3);
text(maxX,upperCI(1,1),'+95%CI','fontsize',35,'fontweight','bold','fontweight','bold')
plot(meanLine,lowerCI,'r--','linewidth',3);
%text(maxX,lowerCI(1,1),'-95%CI','fontsize',35,'fontweight','bold','fontweight','bold')
ylabel(yTitle,'Fontweight','bold','Fontsize',35);
xlabel(xTitle,'Fontweight','bold','Fontsize',35);
set(gca,'fontsize',35,'fontname','Gill Sans MT')
title(dataTitle,'Fontweight','bold','Fontsize',40);
%text(minX*1.2,yMax*.9,strcat('r =',{' '},num2str(round(r,2))),'bold','Fontsize',18);
%text(minX*1.2,yMax*.8,strcat('y =',{' '},num2str(round(trendVar(1,1),2)),'+',num2str(round(trendVar(1,2),2))),'bold','Fontsize',18);
axis([minX maxX -yMax yMax])
set(gca, 'Ticklength', [0 0])
axis square
set(gcf, 'Visible','off');

%depVar = struct('StandardErrorMean',SEM,'MeanDifference',meanDiff(1,1),'StandardDeviation',SDmeanDiff,'Upper95ConfidenceInterval',upperCI(1,1),'Lower95ConfidenceInterval',lowerCI(1,1),'Upper95LimitOfAgreement',upper95LoA(1,1),'Lower95LimitOfAgreement',lower95LoA(1,1));
%display(depVar)
%pause

%%saves a tiff file of the synchrnonization of the data
f=gcf; %f is the handle of the figure you want to export
figpos=getpixelposition(f); %dont need to change anything here
resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
path= pwd; %the folder where you want to put the file

name = char(strcat('Bland-Altman',{' - '},dataTitle,'.tiff'));
print(f,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
close all;clc