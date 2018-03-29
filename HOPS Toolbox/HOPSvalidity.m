clear; close all; clc;
folder_name = uigetdir; %select participant folder
cd(folder_name)

subject = strsplit(folder_name,'\');%subject name generated from folder
subject = char(subject(:,end));
subject = char(strsplit(subject,'_'));

TF = exist(char(strcat('HOPS_',subject,'.mat')));

if TF>0
load(char(strcat('HOPS_',subject,'.mat')));
end

setup = input('Are you using a multiple screen setup or laptop only?\n (1) Multiple screens \n (2) Laptop only\n');

[b,a] = butter(2,2*(6/75),'low');%filtering parameters: 6 Hz low-pass Butterworth filter

subjectNum = str2num(subject); %#ok<*ST2NM>
if subjectNum==6
    f = 1500;%one subject was left at the set trial duration of 10 sec
else
    f = 1050;%frames per trial(duration in sec x sampling rate)
end

heading = {'Trial Target Amplitude',strcat('Oculus Position Angle (',sprintf('%c', char(176)),')'),strcat('Qualisys Position Angle (',sprintf('%c', char(176)),')'),strcat('System Position Angle (',sprintf('%c', char(176)),') Difference'),strcat('System Position Angle (',sprintf('%c', char(176)),') Mean'),'Oculus Gain'...
    ,strcat('Oculus Velocity TO Target (',sprintf('%c', char(176)),'s-1)'),strcat('Qualisys Velocity TO Target (',sprintf('%c', char(176)),'s-1)'),strcat('System Velocity TO (',sprintf('%c', char(176)),'-1) Difference'),strcat('System Velocity TO (',sprintf('%c', char(176)),'-1) Mean')...
    ,strcat('Oculus Velocity FROM Target (',sprintf('%c', char(176)),'s-1)'),strcat('Qualisys Velocity FROM Target (',sprintf('%c', char(176)),'s-1)'),strcat('System Velocity FROM (',sprintf('%c', char(176)),'-1) Difference'),strcat('System Velocity FROM (',sprintf('%c', char(176)),'-1) Mean')...
    ,strcat('Oculus Acceleration TO Target (',sprintf('%c', char(176)),'s-1)'),strcat('Qualisys Acceleration TO Target (',sprintf('%c', char(176)),'s-1)'),strcat('System Acceleration TO (',sprintf('%c', char(176)),'-1) Difference'),strcat('System Acceleration TO (',sprintf('%c', char(176)),'-1) Mean')...
    ,strcat('Oculus Acceleration FROM Target (',sprintf('%c', char(176)),'s-1)'),strcat('Qualisys Acceleration FROM Target (',sprintf('%c', char(176)),'s-1)'),strcat('System Acceleration FROM (',sprintf('%c', char(176)),'-1) Difference'),strcat('System Acceleration FROM (',sprintf('%c', char(176)),'-1) Mean')};

MainFilename = sprintf(strcat(subject,'-HOPS.xlsx'));

HOPSdata.rawData.oculusYawData = oculusimport(subject,'Yaw');%imports oculus Rift time series and book mark data
HOPSdata.rawData.qualisysYawData = qualisysimport(subject,'Yaw');%imports qualisys motion data
HOPSdata.synchronizedData.yawData = syncOculusQualisys(subject,'Yaw',HOPSdata.rawData.oculusYawData.oculusTimeSeries,HOPSdata.rawData.qualisysYawData,HOPSdata.rawData.oculusYawData.oculusTime,HOPSdata.rawData.oculusYawData.oculusStart);%synchronizes oculus and qualisys data using an event-based (ROM) sync and timestamps to cut data to only include the experimental session
HOPSdata.filteredData.oculusYawData = filtfilt(b,a,HOPSdata.synchronizedData.yawData.oculusData);%filters data using a low-pass (6Hz) Butterworth filter on data collected at 75Hz
HOPSdata.filteredData.qualisysYawData = filtfilt(b,a,HOPSdata.synchronizedData.yawData.qualisysData);

trials = 40;
HOPSdata.timeseries.Yaw = HOPSprocess('Yaw',HOPSdata.filteredData.oculusYawData,HOPSdata.filteredData.qualisysYawData,trials,f,HOPSdata.rawData.oculusYawData.oculusMarks,setup,HOPSdata.rawData.oculusYawData.oculusMarks);%processes session data into individual trials and performs additional synchronization to correct for variable sampling of Oculus Rift
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis
HOPSdata.variables.Yaw = HOPSanalyze('Yaw',HOPSdata.timeseries.Yaw,trials,HOPSdata.rawData.oculusYawData.oculusMarks,setup,f);%analyzes the data and picks out specific variables for subsequent statistical analysis
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis

HOPSdata.means.Yaw = [];
yawTemp = HOPSdata.variables.Yaw;

for i = 1:8%calculates the mean of the 5 trials from each trial angle
    HOPSdata.means.Yaw = vertcat(HOPSdata.means.Yaw,nanmean(yawTemp(1:5,1:end)));
    yawTemp(1:5,:) = [];
end

xlswrite(MainFilename,heading,'Yaw Validity Data','A1');%exports data to an Excel file for data visualization and import into SPSS
xlswrite(MainFilename,HOPSdata.variables.Yaw,'Yaw Validity Data','A2');
xlswrite(MainFilename,heading,'Yaw Mean Data','A1');
xlswrite(MainFilename,HOPSdata.means.Yaw,'Yaw Mean Data','A2');

HOPSdata.rawData.oculusPitchData = oculusimport(subject,'Pitch');
HOPSdata.rawData.qualisysPitchData = qualisysimport(subject,'Pitch');
HOPSdata.synchronizedData.pitchData = syncOculusQualisys(subject,'Pitch',HOPSdata.rawData.oculusPitchData.oculusTimeSeries,HOPSdata.rawData.qualisysPitchData,HOPSdata.rawData.oculusPitchData.oculusTime,HOPSdata.rawData.oculusPitchData.oculusStart);
HOPSdata.filteredData.oculusPitchData = filtfilt(b,a,HOPSdata.synchronizedData.pitchData.oculusData);
HOPSdata.filteredData.qualisysPitchData = filtfilt(b,a,HOPSdata.synchronizedData.pitchData.qualisysData);

if subjectNum<4
    trials = 35;%subject 1-3 have 35 trials in the pitch session
else
    trials = 30;
end

HOPSdata.timeseries.Pitch = HOPSprocess('Pitch',HOPSdata.filteredData.oculusPitchData,HOPSdata.filteredData.qualisysPitchData,trials,f,HOPSdata.rawData.oculusPitchData.oculusMarks,setup,HOPSdata.rawData.oculusPitchData.oculusMarks);
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis
HOPSdata.variables.Pitch = HOPSanalyze('Pitch',HOPSdata.timeseries.Pitch,trials,HOPSdata.rawData.oculusPitchData.oculusMarks,setup,f);
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis

HOPSdata.means.Pitch = [];
pitchTemp = HOPSdata.variables.Pitch;

if subjectNum<5
    t = 7;%subject 1-4 have 35 trials in the pitch session
else
    t = 6;
end

for i = 1:t%calculates the mean of the 5 trials from each trial angle
    HOPSdata.means.Pitch = vertcat(HOPSdata.means.Pitch,nanmean(pitchTemp(1:5,1:end)));
    pitchTemp(1:5,:) = [];
end

xlswrite(MainFilename,heading,'Pitch Validity Data','A1');%exports data to an Excel file for data visualization and import into SPSS
xlswrite(MainFilename,HOPSdata.variables.Pitch,'Pitch Validity Data','A2');
xlswrite(MainFilename,heading,'Pitch Mean Data','A1');
xlswrite(MainFilename,HOPSdata.means.Pitch,'Pitch Mean Data','A2');

HOPSdata.rawData.oculusRollData = oculusimport(subject,'Roll');
HOPSdata.rawData.qualisysRollData = qualisysimport(subject,'Roll');
HOPSdata.synchronizedData.rollData = syncOculusQualisys(subject,'Roll',HOPSdata.rawData.oculusRollData.oculusTimeSeries,HOPSdata.rawData.qualisysRollData,HOPSdata.rawData.oculusRollData.oculusTime,HOPSdata.rawData.oculusRollData.oculusStart);
HOPSdata.filteredData.oculusRollData = filtfilt(b,a,HOPSdata.synchronizedData.rollData.oculusData);
HOPSdata.filteredData.qualisysRollData = filtfilt(b,a,HOPSdata.synchronizedData.rollData.qualisysData);

trials = 30;
HOPSdata.timeseries.Roll = HOPSprocess('Roll',HOPSdata.filteredData.oculusRollData,HOPSdata.filteredData.qualisysRollData,trials,f,HOPSdata.rawData.oculusRollData.oculusMarks,setup,HOPSdata.rawData.oculusRollData.oculusMarks);
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis
HOPSdata.variables.Roll = HOPSanalyze('Roll',HOPSdata.timeseries.Roll,trials,HOPSdata.rawData.oculusRollData.oculusMarks,setup,f);
save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis

HOPSdata.means.Roll = [];
rollTemp = HOPSdata.variables.Roll;

for i = 1:6%calculates the mean of the 5 trials from each trial angle
    HOPSdata.means.Roll = vertcat(HOPSdata.means.Roll,nanmean(rollTemp(1:5,1:end)));
    rollTemp(1:5,:) = [];
end

xlswrite(MainFilename,heading,'Roll Validity Data','A1');%exports data to an Excel file for data visualization and import into SPSS
xlswrite(MainFilename,HOPSdata.variables.Roll,'Roll Validity Data','A2');
xlswrite(MainFilename,heading,'Roll Mean Data','A1');
xlswrite(MainFilename,HOPSdata.means.Roll,'Roll Mean Data','A2');

deletesheet(folder_name,MainFilename);%deletes empty sheet in Excel file
clearvars -except subject HOPSdata

save(char(strcat('HOPS_',subject,'.mat')));%saves data for future analysis
display(char(strcat('HOPS validity analysis for',{' '},subject, {' '}, 'complete')));
tts('HOPS validity complete.');
pause(5)
clear; close all; clc;