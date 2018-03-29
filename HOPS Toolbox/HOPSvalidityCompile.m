clear; close all; clc;
folder_name = uigetdir;%open the main directory that has all participant folders
cd(folder_name)
name = [folder_name '\*\**.mat'];
files = rdir(name);%sequentially goes through each subfolder to find the .mat file
nFiles = length(files);%determines how many of the participant folders have a .mat file (if this is fewer than the numner of folders, then one or more partiipants were not processed

warning('off','all');
mainFilename = sprintf('HOPS - Validity Data.xlsx');

yawAngles = {'Neg75','Neg45','Neg30','Neg15','Pos15','Pos30','Pos45','Pos75'};
headingFinal = {};

for i = 1:8
    angle = char(yawAngles(:,i));
    heading = {char(strcat('Trial Target Amplitude',{' '},angle)),char(strcat('Oculus Position Angle',{' '},angle)),char(strcat('Qualisys Position Angle',{' '},angle)),char(strcat('System Position Angle Difference/Error',{' '},angle)),char(strcat('System Position Angle Mean',{' '},angle)),char(strcat('Oculus to Qualisys Ratio',{' '},angle))...
        ,char(strcat('Oculus Velocity TO',{' '},angle)),char(strcat('Qualisys Velocity TO',{' '},angle)),char(strcat('System Velocity TO Difference',{' '},angle)),char(strcat('System Velocity TO Mean',{' '},angle))...
        ,char(strcat('Oculus Velocity FROM',{' '},angle)),char(strcat('Qualisys Velocity FROM',{' '},angle)),char(strcat('System Velocity FROM Difference',{' '},angle)),char(strcat('System Velocity FROM Mean',{' '},angle))...
        ,char(strcat('Oculus Acceleration TO',{' '},angle)),char(strcat('Qualisys Acceleration TO',{' '},angle)),char(strcat('System Acceleration TO Difference',{' '},angle)),char(strcat('System Acceleration TO Mean',{' '},angle))...
        ,char(strcat('Oculus Acceleration FROM',{' '},angle)),char(strcat('Qualisys Acceleration FROM',{' '},angle)),char(strcat('System Acceleration FROM Difference',{' '},angle)),char(strcat('System Acceleration FROM Mean',{' '},angle))};
    headingFinal = horzcat(headingFinal,heading);
end

headingFinal = horzcat('Subject',headingFinal);

xlswrite(mainFilename,headingFinal,'Yaw Raw Data','A1');
xlswrite(mainFilename,headingFinal,'Yaw Mean Data','A1');

pitchAngles = {'Neg75','Neg45','Neg30','Neg15','Pos15','Pos30'};
headingFinal = {};

for i = 1:6
    angle = char(pitchAngles(:,i));
    heading = {char(strcat('Trial Target Amplitude',{' '},angle)),char(strcat('Oculus Position Angle',{' '},angle)),char(strcat('Qualisys Position Angle',{' '},angle)),char(strcat('System Position Angle Difference/Error',{' '},angle)),char(strcat('System Position Angle Mean',{' '},angle)),char(strcat('Oculus to Qualisys Ratio',{' '},angle))...
        ,char(strcat('Oculus Velocity TO',{' '},angle)),char(strcat('Qualisys Velocity TO',{' '},angle)),char(strcat('System Velocity TO Difference',{' '},angle)),char(strcat('System Velocity TO Mean',{' '},angle))...
        ,char(strcat('Oculus Velocity FROM',{' '},angle)),char(strcat('Qualisys Velocity FROM',{' '},angle)),char(strcat('System Velocity FROM Difference',{' '},angle)),char(strcat('System Velocity FROM Mean',{' '},angle))...
        ,char(strcat('Oculus Acceleration TO',{' '},angle)),char(strcat('Qualisys Acceleration TO',{' '},angle)),char(strcat('System Acceleration TO Difference',{' '},angle)),char(strcat('System Acceleration TO Mean',{' '},angle))...
        ,char(strcat('Oculus Acceleration FROM',{' '},angle)),char(strcat('Qualisys Acceleration FROM',{' '},angle)),char(strcat('System Acceleration FROM Difference',{' '},angle)),char(strcat('System Acceleration FROM Mean',{' '},angle))};
    headingFinal = horzcat(headingFinal,heading);
end

headingFinal = horzcat('Subject',headingFinal);

xlswrite(mainFilename,headingFinal,'Pitch Raw Data','A1');
xlswrite(mainFilename,headingFinal,'Pitch Mean Data','A1');

rollAngles = {'Neg45','Neg30','Neg15','Pos15','Pos30','Pos45'};
headingFinal = {};

for i = 1:6
    angle = char(rollAngles(:,i));
    heading = {char(strcat('Trial Target Amplitude',{' '},angle)),char(strcat('Oculus Position Angle',{' '},angle)),char(strcat('Qualisys Position Angle',{' '},angle)),char(strcat('System Position Angle Difference/Error',{' '},angle)),char(strcat('System Position Angle Mean',{' '},angle)),char(strcat('Oculus to Qualisys Ratio',{' '},angle))...
        ,char(strcat('Oculus Velocity TO',{' '},angle)),char(strcat('Qualisys Velocity TO',{' '},angle)),char(strcat('System Velocity TO Difference',{' '},angle)),char(strcat('System Velocity TO Mean',{' '},angle))...
        ,char(strcat('Oculus Velocity FROM',{' '},angle)),char(strcat('Qualisys Velocity FROM',{' '},angle)),char(strcat('System Velocity FROM Difference',{' '},angle)),char(strcat('System Velocity FROM Mean',{' '},angle))...
        ,char(strcat('Oculus Acceleration TO',{' '},angle)),char(strcat('Qualisys Acceleration TO',{' '},angle)),char(strcat('System Acceleration TO Difference',{' '},angle)),char(strcat('System Acceleration TO Mean',{' '},angle))...
        ,char(strcat('Oculus Acceleration FROM',{' '},angle)),char(strcat('Qualisys Acceleration FROM',{' '},angle)),char(strcat('System Acceleration FROM Difference',{' '},angle)),char(strcat('System Acceleration FROM Mean',{' '},angle))};
    headingFinal = horzcat(headingFinal,heading);
end

headingFinal = horzcat('Subject',headingFinal);

xlswrite(mainFilename,headingFinal,'Roll Raw Data','A1');
xlswrite(mainFilename,headingFinal,'Roll Mean Data','A1');
deletesheet(pwd,mainFilename);

yawRawData = [];
pitchRawData = [];
rollRawData = [];

yawMeanData = [];
pitchMeanData = [];
rollMeanData = [];

for i = 1:nFiles
    filename = char({files(i,1).name});
    load(filename)
    allSubjects(i,:) = str2num(subject);
    
    subjectID(1:40,:) = cellstr(subject);
    yawRawSubjectData = [subjectID,num2cell(HOPSdata.variables.Yaw)];
    yawRawData = vertcat(yawRawData,yawRawSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectID(1:8,:) = cellstr(subject);
    yawMeanSubjectData = [subjectID,num2cell(HOPSdata.means.Yaw)];
    yawMeanData = vertcat(yawMeanData,yawMeanSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectNum = str2num(subject); %#ok<*ST2NM>
    if subjectNum<5
        subjectID(1:35,:) = cellstr(subject);
    else
        subjectID(1:30,:) = cellstr(subject);
    end
    
    pitchSubjectData = [subjectID,num2cell(HOPSdata.variables.Pitch)];
    pitchRawData = vertcat(pitchRawData,pitchSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectNum = str2num(subject); %#ok<*ST2NM>
    if subjectNum<5
        subjectID(1:7,:) = cellstr(subject);
    else
        subjectID(1:6,:) = cellstr(subject);
    end
    
    pitchMeanSubjectData = [subjectID,num2cell(HOPSdata.means.Pitch)];
    pitchMeanData = vertcat(pitchMeanData,pitchMeanSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectID(1:30,:) = cellstr(subject);
    
    rollSubjectData = [subjectID,num2cell(HOPSdata.variables.Roll)];
    rollRawData = vertcat(rollRawData,rollSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
    subjectID(1:6,:) = cellstr(subject);
    rollMeanSubjectData = [subjectID,num2cell(HOPSdata.means.Roll)];
    rollMeanData = vertcat(rollMeanData,rollMeanSubjectData); %#ok<*AGROW>
    
    clearvars subjectID
end

clearvars -except allSubjects yawRawData pitchRawData rollRawData yawMeanData pitchMeanData rollMeanData nFiles mainFilename

yawRawData = sortrows(yawRawData,2);
pitchRawData = sortrows(pitchRawData,2);
rollRawData = sortrows(rollRawData,2);
pitchRawData(end-19:end,:) = [];%removes 45 deg trials from pitch data (not collected with every subject)

plane = {'Yaw','Pitch','Roll'};
headingFinal = {};

for i = 1:3   
    heading = {'Subject','Trial Target Amplitude',char(strcat('Oculus Position Angle',{' '},plane(:,i))),char(strcat('Qualisys Position Angle',{' '},plane(:,i))),char(strcat('System Position Angle Difference/Error',{' '},plane(:,i))),char(strcat('System Position Angle Mean',{' '},plane(:,i))),'Oculus to Qualisys Ratio'...
        ,char(strcat('Oculus Velocity TO',{' '},plane(:,i))),char(strcat('Qualisys Velocity TO',{' '},plane(:,i))),char(strcat('System Velocity TO Difference',{' '},plane(:,i))),char(strcat('System Velocity TO Mean',{' '},plane(:,i)))...
        ,char(strcat('Oculus Velocity FROM',{' '},plane(:,i))),char(strcat('Qualisys Velocity FROM',{' '},plane(:,i))),char(strcat('System Velocity FROM Difference',{' '},plane(:,i))),char(strcat('System Velocity FROM Mean',{' '},plane(:,i)))...
        ,char(strcat('Oculus Acceleration TO',{' '},plane(:,i))),char(strcat('Qualisys Acceleration TO',{' '},plane(:,i))),char(strcat('System Acceleration TO Difference',{' '},plane(:,i))),char(strcat('System Acceleration TO Mean',{' '},plane(:,i)))...
        ,char(strcat('Oculus Acceleration FROM',{' '},plane(:,i))),char(strcat('Qualisys Acceleration FROM',{' '},plane(:,i))),char(strcat('System Acceleration FROM Difference',{' '},plane(:,i))),char(strcat('System Acceleration FROM Mean',{' '},plane(:,i)))};
    headingFinal = horzcat(headingFinal,heading);
end

xlswrite(mainFilename,headingFinal,'All Raw Data','A1');
xlswrite(mainFilename,headingFinal,'All Mean Data','A1');

xlswrite(mainFilename,yawRawData,'All Raw Data','A2');
xlswrite(mainFilename,pitchRawData,'All Raw Data','X2');
xlswrite(mainFilename,rollRawData,'All Raw Data','AU2');

xlswrite(mainFilename,yawMeanData,'All Mean Data','A2');
xlswrite(mainFilename,pitchMeanData,'All Mean Data','X2');
xlswrite(mainFilename,rollMeanData,'All Mean Data','AU2');

yawRaw = str2num(cell2mat(yawRawData(1:nFiles*5,1))); %#ok<*NBRAK>
yawTemp = cell2mat(yawRawData(:,2:end));

for i = 1:8
    yawRaw = horzcat(yawRaw,yawTemp(1:nFiles*5,:));
    yawTemp(1:nFiles*5,:) = [];
end

xlswrite(mainFilename,yawRaw,'Yaw Raw Data','A2');

pitchRaw = str2num(cell2mat(pitchRawData(1:nFiles*5,1))); %#ok<*NBRAK>
pitchTemp = cell2mat(pitchRawData(:,2:end));

for i = 1:6
    pitchRaw = horzcat(pitchRaw,pitchTemp(1:nFiles*5,:));
    pitchTemp(1:nFiles*5,:) = [];
end

xlswrite(mainFilename,pitchRaw,'Pitch Raw Data','A2');

rollRaw = str2num(cell2mat(rollRawData(1:nFiles*5,1))); %#ok<*NBRAK>
rollTemp = cell2mat(rollRawData(:,2:end));

for i = 1:6
    rollRaw = horzcat(rollRaw,rollTemp(1:nFiles*5,:));
    rollTemp(1:nFiles*5,:) = [];
end

xlswrite(mainFilename,rollRaw,'Roll Raw Data','A2');

yawMeanData = sortrows(yawMeanData,2);
pitchMeanData = sortrows(pitchMeanData,2);
rollMeanData = sortrows(rollMeanData,2);
pitchMeanData(end-3:end,:) = [];%removes 45 deg trials from pitch data (not collected with every subject)

yawANOVA = allSubjects; %#ok<*NBRAK>
yawTemp = cell2mat(yawMeanData(:,2:end));

for i = 1:8
    yawANOVA = horzcat(yawANOVA,yawTemp(1:nFiles,:));
    yawTemp(1:nFiles,:) = [];
end

xlswrite(mainFilename,yawANOVA,'Yaw Mean Data','A2');

pitchANOVA = allSubjects; %#ok<*NBRAK>
pitchTemp = cell2mat(pitchMeanData(:,2:end));
rollANOVA = allSubjects; %#ok<*NBRAK>
rollTemp = cell2mat(rollMeanData(:,2:end));

for i = 1:6
    pitchANOVA = horzcat(pitchANOVA,pitchTemp(1:nFiles,:));
    pitchTemp(1:nFiles,:) = [];
    rollANOVA = horzcat(rollANOVA,rollTemp(1:nFiles,:));
    rollTemp(1:nFiles,:) = [];
end

xlswrite(mainFilename,pitchANOVA,'Pitch Mean Data','A2');
xlswrite(mainFilename,rollANOVA,'Roll Mean Data','A2');

BlandAltmanHeadings = {'Displacment','Velocity TO','Velocity FROM','Acceleration TO','Acceleration FROM'};
timeseries = {'displacement','velocity','velocity','acceleration','acceleration'};
yawTemp = cell2mat(yawRawData(:,2:end));
oculusData = [yawTemp(:,2),yawTemp(:,7),yawTemp(:,11),yawTemp(:,15),yawTemp(:,19)];
qualisysData = [yawTemp(:,3),yawTemp(:,8),yawTemp(:,12),yawTemp(:,16),yawTemp(:,20)];

for ii = 1:5%bland-altman plots for all trial angles
    blandaltplot(oculusData(:,ii),qualisysData(:,ii),strcat('Yaw',{' '},BlandAltmanHeadings(:,ii)),char(timeseries(:,ii)));
end
%%
clearvars oculusData qualisysData

for i = 1:8%bland-altman plots for individiual trial angles
    oculusData = [yawTemp(1:nFiles*5,2),yawTemp(1:nFiles*5,7),yawTemp(1:nFiles*5,11),yawTemp(1:nFiles*5,15),yawTemp(1:nFiles*5,19)];
    qualisysData = [yawTemp(1:nFiles*5,3),yawTemp(1:nFiles*5,8),yawTemp(1:nFiles*5,12),yawTemp(1:nFiles*5,16),yawTemp(1:nFiles*5,20)];
    trialAngle = num2str(yawTemp(1,1));
    yawTemp(1:nFiles*5,:) = [];
    
    for ii = 1:5
        blandaltplot(oculusData(:,ii),qualisysData(:,ii),strcat('Yaw',{' '},BlandAltmanHeadings(:,ii),{' ('},trialAngle,')'),char(timeseries(:,ii)));
    end
end

pitchTemp = cell2mat(pitchRawData(:,2:end));
oculusData = [pitchTemp(:,2),pitchTemp(:,7),pitchTemp(:,11),pitchTemp(:,15),pitchTemp(:,19)];
qualisysData = [pitchTemp(:,3),pitchTemp(:,8),pitchTemp(:,12),pitchTemp(:,16),pitchTemp(:,20)];

for ii = 1:5%bland-altman plots for all trial angles
    blandaltplot(oculusData(:,ii),qualisysData(:,ii),strcat('Pitch',{' '},BlandAltmanHeadings(:,ii)),char(timeseries(:,ii)));
end

clearvars oculusData qualisysData

for i = 1:6
    oculusData = [pitchTemp(1:nFiles*5,2),pitchTemp(1:nFiles*5,7),pitchTemp(1:nFiles*5,11),pitchTemp(1:nFiles*5,15),pitchTemp(1:nFiles*5,19)];
    qualisysData = [pitchTemp(1:nFiles*5,3),pitchTemp(1:nFiles*5,8),pitchTemp(1:nFiles*5,12),pitchTemp(1:nFiles*5,16),pitchTemp(1:nFiles*5,20)];
    trialAngle = num2str(pitchTemp(1,1));
    pitchTemp(1:nFiles*5,:) = [];
    
    for ii = 1:5
        blandaltplot(oculusData(:,ii),qualisysData(:,ii),strcat('Pitch',{' '},BlandAltmanHeadings(:,ii),{' ('},trialAngle,')'),char(timeseries(:,ii)));
    end
end

rollTemp = cell2mat(rollRawData(:,2:end));
oculusData = [rollTemp(:,2),rollTemp(:,7),rollTemp(:,11),rollTemp(:,15),rollTemp(:,19)];
qualisysData = [rollTemp(:,3),rollTemp(:,8),rollTemp(:,12),rollTemp(:,16),rollTemp(:,20)];

for ii = 1:5%bland-altman plots for all trial angles
    blandaltplot(oculusData(:,ii),qualisysData(:,ii),strcat('Roll',{' '},BlandAltmanHeadings(:,ii)),char(timeseries(:,ii)));
end

clearvars oculusData qualisysData

for i = 1:6
    oculusData = [rollTemp(1:nFiles*5,2),rollTemp(1:nFiles*5,7),rollTemp(1:nFiles*5,11),rollTemp(1:nFiles*5,15),rollTemp(1:nFiles*5,19)];
    qualisysData = [rollTemp(1:nFiles*5,3),rollTemp(1:nFiles*5,8),rollTemp(1:nFiles*5,12),rollTemp(1:nFiles*5,16),rollTemp(1:nFiles*5,20)];
    trialAngle = num2str(rollTemp(1,1));
    rollTemp(1:nFiles*5,:) = [];
    
    for ii = 1:5
        blandaltplot(oculusData(:,ii),qualisysData(:,ii),strcat('Roll',{' '},BlandAltmanHeadings(:,ii),{' ('},trialAngle,')'),char(timeseries(:,ii)));
    end
end

msgbox('HOPS Validity Data Compiled');
tts('HOPS Validity Data Compiled');
clear
clc