function qualisysData = qualisysimport(subject,plane)

study = strsplit(pwd,'\');%subject name generated from folder
study = char(study(:,end-1));

TF = strcmp(study,'Pilot Validation and Joint Position Matching Data');

if TF==1
    filename = strcat(subject,'Qualisys_6D.tsv');
else
    filename = strcat(subject,'_',plane,'_6D.tsv');%imports data from modeled head data in qualisys (requires processing in QTM prior to analysis)
end

delimiter = '\t';%necessary information to import qualisys files
startRow = 12;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

TF = strcmp('Yaw',plane);

if TF==1
    qualisysData = -dataArray{:,8};
else
    TF = strcmp('Pitch',plane);
    if  TF==1
        qualisysData = -dataArray{:,6};
    else
        qualisysData = -dataArray{:,7};
    end
end