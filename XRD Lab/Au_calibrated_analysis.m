%set working directory
%cd G:'Shared drives'\'MSE 361 Instructors'\'General course files'\'Lab Materials'\'X-Ray Powder Diffraction'\MATLAB\

%% clear
clear
clc
close all

%% import the data file
AuCalTable = readtable("Au calibrated.txt");
AuCal = table2array(AuCalTable);
angle = AuCal(:,2);
int = AuCal(:,3);

%% Plot the raw data
fig1 = figure;
plot(angle,int)
xlim([0 120])
title('Au Calibrated')
xlabel('2\theta')
ylabel('Intensity')

%% Find the peaks
findpeaks = islocalmax(int,'MinProminence',650);
plot(angle,int,angle(findpeaks),int(findpeaks),'r*')
peaks = [nonzeros(angle.*findpeaks)];
peaks(end) = [];
peaklist = [nonzeros(angle.*findpeaks),nonzeros(int.*findpeaks)];
peaklist(end,:) = [];
indexlist = [1 1 1;2 0 0;2 2 0;3 1 1;2 2 2;4 0 0;3 3 1;];
peaklist = cat(2,peaklist,indexlist);
xlim([20 120])
title('Au')
xlabel('2\theta')
ylabel('Intensity')

%% Sample displacement error
fig2 = figure;
twotheta = peaks;
theta = peaks/2;
lambda = 1.5406;
d = lambda./(2*sind(theta));
a = d.*sqrt((indexlist(:,1).^2+indexlist(:,2).^2+indexlist(:,3).^2));
cos2ThB = cosd(theta).^2;
plot(cos2ThB,a);

%% fit line to sample displacement error
p2 = polyfit(cos2ThB,a,1);
f2 = polyval(p2,cos2ThB);
plot(cos2ThB,a,'o',cos2ThB,f2,'-');
legend('data','linear fit')
a_calc =(p2(2))

%% Find what should have been
d_calc = a_calc./sqrt((indexlist(:,1).^2+indexlist(:,2).^2+indexlist(:,3).^2));
theta_calc = asind(lambda./(2.*d_calc));
twotetha_calc = theta_calc.*2;
dtwotheta = abs(twotetha_calc - twotheta);

%% New plot of dtwotheta vs. sin(2thb)
fig3 = figure;
p3 = polyfit(sind(twotheta),dtwotheta,1);
f3 = polyval(p3,sind(twotheta));
plot(sind(twotheta), dtwotheta, 'o',sind(twotheta),f3,'-')
slope3 = p3(1)