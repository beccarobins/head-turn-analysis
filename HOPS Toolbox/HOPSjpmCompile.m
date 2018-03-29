clear; close all; clc;
folder_name = uigetdir;%open the main directory that has all participant folders
cd(folder_name)
name = [folder_name '\*\**.mat'];
files = rdir(name);%sequentially goes through each subfolder to find the .mat file
nFiles = length(files);%determines how many of the participant folders have a .mat file (if this is fewer than the numner of folders, then one or more partiipants were not processed

warning('off','all');
mainFilename = sprintf('HOPS - JPM Pilot Data.xlsx');
heading = {'Subject','Trial Target Amplitude',strcat('Oculus Position Angle (',sprintf('%c', char(176)),')'),strcat('Qualisys Position Angle (',sprintf('%c', char(176)),')'),strcat('System Position Angle (',sprintf('%c', char(176)),') Difference/Error'),strcat('System Position Angle (',sprintf('%c', char(176)),') Mean'),'Oculus to Qualisys Ratio'};
heading2 = horzcat(heading,heading(2:end),heading(2:end),heading(2:end),heading(2:end),heading(2:end));
heading3 = horzcat(heading,heading(2:end),heading(2:end));
xlswrite(mainFilename,heading,'Raw Validity Data','A1');
xlswrite(mainFilename,heading2,'Mean Validity Data','A1');
xlswrite(mainFilename,heading3,'Pooled Mean Validity Data','A1');
deletesheet(pwd,mainFilename);
heading = {'Subject','Trial Angle','Position Measurement','Match Measurement','Constant Error','Absolute Error'};
heading2 = horzcat(heading,heading(2:end),heading(2:end),heading(2:end),heading(2:end),heading(2:end));
heading3 = horzcat(heading,heading(2:end),heading(2:end));
xlswrite(mainFilename,heading,'Raw JPM Data','A1');
xlswrite(mainFilename,heading2,'Mean JPM Data','A1');
xlswrite(mainFilename,heading3,'Pooled Mean JPM Data','A1');

validityRawData = [];
validityMeanData = [];
validityPooledMeanData = [];

jpmRawData = [];
jpmMeanData = [];
jpmPooledMeanData = [];

for i = 1:nFiles
    filename = char({files(i,1).name});
    load(filename)
    
    subjectID(1:30,:) = cellstr(subject);
    validitySubjectData = [subjectID,num2cell(HOPSdata.variables.Yaw.validity)];
    validityRawData = vertcat(validityRawData,validitySubjectData); %#ok<*AGROW>
    jpmSubjectData = [subjectID,num2cell(HOPSdata.variables.Yaw.JPM)];
    jpmRawData = vertcat(jpmRawData,jpmSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectID(1:6,:) = cellstr(subject);
    validityMeanSubjectData = [subjectID,num2cell(HOPSdata.means.Yaw.validity)];
    validityMeanData = vertcat(validityMeanData,validityMeanSubjectData); %#ok<*AGROW>
    jpmMeanSubjectData = [subjectID,num2cell(HOPSdata.means.Yaw.JPM)];
    jpmMeanData = vertcat(jpmMeanData,jpmMeanSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectID(1:3,:) = cellstr(subject);
    validityPooledMeanSubjectData = [subjectID,num2cell(HOPSdata.pooledMeans.Yaw.validity)];
    validityPooledMeanData = vertcat(validityPooledMeanData,validityPooledMeanSubjectData); %#ok<*AGROW>
    jpmPooledMeanSubjectData = [subjectID,num2cell(HOPSdata.pooledMeans.Yaw.JPM)];
    jpmPooledMeanData = vertcat(jpmPooledMeanData,jpmPooledMeanSubjectData); %#ok<*AGROW>
    
end

clearvars -except nFiles validityRawData validityMeanData validityPooledMeanData jpmRawData jpmMeanData jpmPooledMeanData mainFilename

validityMeanData = sortrows(validityMeanData,2);
validityPooledMeanData = sortrows(validityPooledMeanData,2);
jpmMeanData = sortrows(jpmMeanData,2);
jpmPooledMeanData = sortrows(jpmPooledMeanData,2);

validityANOVA = str2num(cell2mat(validityMeanData(1:nFiles,1))); %#ok<*NBRAK>
temp = cell2mat(validityMeanData(:,2:end));

for i = 1:6
    validityANOVA = horzcat(validityANOVA,temp(1:nFiles,:));
    temp(1:nFiles,:) = [];
end

jpmANOVA = str2num(cell2mat(jpmMeanData(1:nFiles,1))); %#ok<*NBRAK>
temp = cell2mat(jpmMeanData(:,2:end));

for i = 1:6
    jpmANOVA = horzcat(jpmANOVA,temp(1:nFiles,:));
    temp(1:nFiles,:) = [];
end

validityPooledANOVA = str2num(cell2mat(validityPooledMeanData(1:nFiles,1))); %#ok<*NBRAK>
temp = cell2mat(validityPooledMeanData(:,2:end));

for i = 1:3
    validityPooledANOVA = horzcat(validityPooledANOVA,temp(1:nFiles,:));
    temp(1:nFiles,:) = [];
end

jpmPooledANOVA = str2num(cell2mat(jpmPooledMeanData(1:nFiles,1))); %#ok<*NBRAK>
temp = cell2mat(jpmPooledMeanData(:,2:end));

for i = 1:3
    jpmPooledANOVA = horzcat(jpmPooledANOVA,temp(1:nFiles,:));
    temp(1:nFiles,:) = [];
end

xlswrite(mainFilename,validityRawData,'Raw Validity Data','A2');
xlswrite(mainFilename,jpmRawData,'Raw JPM Data','A2');
xlswrite(mainFilename,validityANOVA,'Mean Validity Data','A2');
xlswrite(mainFilename,jpmANOVA,'Mean JPM Data','A2');
xlswrite(mainFilename,validityPooledANOVA,'Pooled Mean Validity Data','A2');
xlswrite(mainFilename,jpmPooledANOVA,'Pooled Mean JPM Data','A2');

%%create Bland-Altman plots

validityTemp = cell2mat(validityRawData(:,2:end));
validityTemp(:,1) = abs(validityTemp(:,1));
validityTemp = sortrows(validityTemp,1);
oculusData = validityTemp(:,2);
qualisysData = validityTemp(:,3);

blandaltplot(oculusData,qualisysData,'Displacement','displacement');

for i = 1:3%bland-altman plots for individiual trial angles
    oculusData = validityTemp(1:nFiles*10,2);
    qualisysData = validityTemp(1:nFiles*10,3);
    trialAngle = num2str(validityTemp(1,1));
    validityTemp(1:nFiles*10,:) = [];
    blandaltplot(oculusData,qualisysData,strcat('Displacement',{' - '},trialAngle),'displacement');
end

msgbox('HOPS Validity Data Compiled');
tts('HOPS Validity Data Compiled');
clear
clc