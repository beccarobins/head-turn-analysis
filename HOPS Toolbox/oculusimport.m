function oculusData = oculusimport(subject,plane)

warning('off');

study = strsplit(pwd,'\');%subject name generated from folder
study = char(study(:,end-1));

TF = strcmp(study,'Pilot Validation and Joint Position Matching Data');

if TF==1
    filename = strcat(subject,'Oculus.txt');
else
    filename = strcat('HOPS1_',subject,'_',plane,'.txt');
end

oculusData = importdata(filename);

TF = strcmp('Yaw',plane);

if TF==1
    oculusTimeSeries = oculusData.data(:,2);%imports oculus time series data
else
    TF = strcmp('Pitch',plane);
    if  TF==1
        oculusTimeSeries = oculusData.data(:,1);
    else
        oculusTimeSeries = oculusData.data(:,3);
    end
end

oculusTime = oculusData.data(:,5);%imports oculus time stamps

delimiter = ' ';%necessary information to import oculus bookmarks tsv file
startRow = 2;
formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';

filename = strcat('HOPS1_',subject,'_',plane,'BOOKMARKS.txt');%bookmark file that contains target amplitude info
%filename = strcat(subject,'OculusBOOKMARKS.txt');
fileID = fopen(filename,'r');
bookmarksDataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

study = strsplit(pwd,'\');%subject name generated from folder
study = char(study(:,end-1));

TF = strcmp(study,'Pilot Validation and Joint Position Matching Data');
subjectNum = str2num(subject);

if TF==1
    if subjectNum<5
        a = bookmarksDataArray{1,5}(5:end,1);
    else
        a = bookmarksDataArray{1,5}(6:end,1);
    end
    oculusMarks=str2double(a);
    oculusMarks= oculusMarks(1:2:end);%removes half the trial info (position and matching are identical)
    for i = 1:length(oculusMarks)%%converts unity units to actual trial angles
        if oculusMarks(i,1)==165
            oculusMarks(i,1)=20;
        end
        if oculusMarks(i,1)==195
            oculusMarks(i,1)=-20;
        end
        if oculusMarks(i,1)==150
            oculusMarks(i,1)=39.25;
        end
        if oculusMarks(i,1)==210
            oculusMarks(i,1)=-39.25;
        end
        if oculusMarks(i,1)==135
            oculusMarks(i,1)=57.25;
        end
        if oculusMarks(i,1)==225
            oculusMarks(i,1)=-57.25;
        end
    end
    oculusStart = bookmarksDataArray{1,4}(1,1);%NOT CLEAR IF THIS IS THE CORRECT TIMESTAMP
    oculusTimeStamps = bookmarksDataArray{1,4}(5:end,1);
    oculusData = v2struct(oculusMarks,oculusStart,oculusTime,oculusTimeSeries,oculusTimeStamps);
else
    a = bookmarksDataArray{1,2}(2:end,1);
    oculusMarks=str2double(a);
    oculusStart = bookmarksDataArray{1,1}(1,1);
    oculusTimeStamps = bookmarksDataArray{1,1}(2:end,1);
    oculusData = v2struct(oculusMarks,oculusStart,oculusTime,oculusTimeSeries,oculusTimeStamps);
end
clc