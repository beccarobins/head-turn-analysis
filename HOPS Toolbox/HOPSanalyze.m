function HOPSoutputVariables = HOPSanalyze(plane,data,trials,trialInfo,setup,f)
%data is all timeseries data (both oculus and qualisys data)
v = f-1;%length of velocity timeseries
a = f-2;%length of acceleration timeseries

displacementVariables = hopsanalyzedisplacement(plane,data,trials,setup,f);
velocityVariables = hopsanalyzevelocity(plane,data,trials,setup,v);
accelerationVariables = hopsanalyzeacceleration(plane,data,trials,setup,a);

HOPSoutputVariables = sortrows([trialInfo,displacementVariables,velocityVariables,accelerationVariables],1);