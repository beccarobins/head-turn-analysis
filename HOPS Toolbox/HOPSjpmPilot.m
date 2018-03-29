clear; close all; clc;
folder_name = uigetdir; %select participant folder
cd(folder_name)

subject = strsplit(folder_name,'\');%subject name generated from folder
subject = char(subject(:,end));
subject = char(strsplit(subject,'_'));
setup = 1;
% setup = input('Are you using a multiple screen setup or laptop only?\n (1) Multiple screens \n (2) Laptop only\n');
[b,a] = butter(2,2*(6/75),'low');%filtering parameters: 6 Hz low-pass Butterworth filter

MainFilename = sprintf(strcat(subject,'-HOPS.xlsx'));%creates Excel filename
Heading = {'Trial Angle','Oculus','Qualisys','System Difference','Mean Measurement','System Error'};
xlswrite(MainFilename,Heading,'Validity','A1');
xlswrite(MainFilename,Heading,'Mean Data','A1');
xlswrite(MainFilename,Heading,'Mean Data','G1');
Heading = {'Trial Angle','Position Measurement','Match Measurement','Constant Error','Absolute Error'};
xlswrite(MainFilename,Heading,'JPM','A1');
warning('off','all');
deletesheet(folder_name,MainFilename);%deletes empty sheet in Excel file

load(char(strcat('HOPS_',subject,'.mat')));

% HOPSdata.rawData.oculusYawData = oculusimport(subject,'Yaw');%imports oculus Rift time series and book mark data
% HOPSdata.rawData.qualisysYawData = qualisysimport(subject,'Yaw');%imports qualisys motion data
% HOPSdata.synchronizedData.yawData = syncOculusQualisys(subject,'Yaw',HOPSdata.rawData.oculusYawData.oculusTimeSeries,HOPSdata.rawData.qualisysYawData,HOPSdata.rawData.oculusYawData.oculusTime,HOPSdata.rawData.oculusYawData.oculusStart);%synchronizes oculus and qualisys data using an event-based (ROM) sync and timestamps to cut data to only include the experimental session
% HOPSdata.filteredData.oculusYawData = filtfilt(b,a,HOPSdata.synchronizedData.yawData.oculusData);%filters data using a low-pass (6Hz) Butterworth filter on data collected at 75Hz
% HOPSdata.filteredData.qualisysYawData = filtfilt(b,a,HOPSdata.synchronizedData.yawData.qualisysData);

trials = 30;
f = 2250;%frames per trial

% HOPSdata.timeseries.Yaw = HOPSprocess('Yaw',HOPSdata.filteredData.oculusYawData,HOPSdata.filteredData.qualisysYawData,trials,f,HOPSdata.rawData.oculusYawData.oculusMarks,setup);%processes session data into individual trials and performs additional synchronization to correct for variable sampling of Oculus Rift
% save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis
HOPSdata.variables.Yaw = HOPSanalyzeJPM('Yaw',HOPSdata.timeseries.Yaw,trials,HOPSdata.rawData.oculusYawData.oculusMarks,setup,f);%analyzes the data and picks out specific variables for subsequent statistical analysis
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis

HOPSdata = rmfield(HOPSdata,'means');
HOPSdata = rmfield(HOPSdata,'pooledMeans');

HOPSdata.means.Yaw.JPM = [];
yawTemp = HOPSdata.variables.Yaw.JPM;

for i = 1:6%calculates the mean of the 5 trials from each trial angle
    HOPSdata.means.Yaw.JPM = vertcat(HOPSdata.means.Yaw.JPM,nanmean(yawTemp(1:5,1:end)));
    yawTemp(1:5,:) = [];
end

HOPSdata.pooledMeans.Yaw.JPM = [];
yawTemp = HOPSdata.variables.Yaw.JPM;
yawTemp(:,1) = abs(yawTemp(:,1));
yawTemp = sortrows(yawTemp,1);

for i = 1:3%calculates the mean of the 5 trials from each trial angle
    HOPSdata.pooledMeans.Yaw.JPM =  vertcat(HOPSdata.pooledMeans.Yaw.JPM,nanmean(yawTemp(1:10,1:end)));
    yawTemp(1:10,:) = [];
end

HOPSdata.means.Yaw.validity = [];
yawTemp = HOPSdata.variables.Yaw.validity;

for i = 1:6%calculates the mean of the 5 trials from each trial angle
    HOPSdata.means.Yaw.validity = vertcat(HOPSdata.means.Yaw.validity,nanmean(yawTemp(1:5,1:end)));
    yawTemp(1:5,:) = [];
end

HOPSdata.pooledMeans.Yaw.validity = [];
yawTemp = HOPSdata.variables.Yaw.validity;
yawTemp(:,1) = abs(yawTemp(:,1));
yawTemp = sortrows(yawTemp,1);

for i = 1:3%calculates the mean of the 5 trials from each trial angle
    HOPSdata.pooledMeans.Yaw.validity =  vertcat(HOPSdata.pooledMeans.Yaw.validity,nanmean(yawTemp(1:10,1:end)));
    yawTemp(1:10,:) = [];
end

xlswrite(MainFilename,HOPSdata.variables.Yaw.validity,'Validity','A2');
xlswrite(MainFilename,HOPSdata.variables.Yaw.JPM,'JPM','A2');
xlswrite(MainFilename,HOPSdata.means.Yaw.JPM,'Mean Data','A2');
xlswrite(MainFilename,HOPSdata.pooledMeans.Yaw.JPM,'Mean Data','G2');

clearvars -except subject HOPSdata

save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis
display(char(strcat('HOPS joint position matching analysis for',{' '},subject, {' '}, 'complete')));
tts('HOPS joint position matching complete.');
clear; close all; clc;