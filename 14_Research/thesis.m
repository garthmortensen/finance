clear all
close all
clc

% load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\research\adjclosingDJ')
% load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\research\adjclosingSZ')

%hmm. i think i should use
%adjusted closing prices, not just closing prices. this will prevent
%stock splits and all from screwing with the data series. "The adjusted
%closing price is a useful tool when examining historical returns because it gives analysts an accurate representation of the firm's equity value beyond the simple market price. It accounts for all corporate actions such as stock splits, dividends/distributions and rights offerings."

%i need to clean the matrices so that they only include days in which both
%markets were trading. maybe this is easier in excel...troubledataset.xls.
%goodnight.

% ok, now regarding multivariate GARCH calculations. I've found the
% UCSD_GARCH toolbox, which first requires the optimization and Econometrics
% Toolbox by James P. LeSage toolboxes. i install the JPL toolbox, without
% this UCSD GARCH folder. after, i install the updated UCSD GARCH folder,
% which now includes multivariate GARCH-BEKK. the Oxford MFE toolbox, soon to replace UCSD GARCH toolbox,hasn't
% yet been updated to included multivariate GARCH-BEKK.
% =========================================================================


load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\research\adjclosingDJ')
% i extract just the column i want from the data
DJ=DJorig(1:end,end);
% now i must log difference. 
DJlog=log(DJ);
DJdiff=DJlog;
plot(DJ)


% The final potion of the demo will be using real data.The data was provided by Andrew Patton 
%  and was used in thepaper,'The conditional Copula in Finance'
% The data set consists of two data series, US-DM and US-Yen Exchange rates.
% The data are 100 times the log diference, and span Jan 1990 throught Dec 1999.
%SKIPPED Multiplying by 100 makes some of the lower bounds easier to work with when the series volatility is very small.
% Press any key for a plot of the data.

