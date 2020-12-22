%Garth Mortensen
%mortensengarth@hotmail.com
%2011 December 01

%%
%%DESCRIPTION
%Bivariate GARCH model

%REQUIREMENTS
%This code requires the James P. LeSage Econometrics Toolbox and UCSD
%GARCH toolboxes to run properly. Verify you have them installed using command 'ver'
%Install/uninstall toolboxes using command 'pathtool.' This code doesnt use
%the adftest that comes with the Econometrics toolbox. Instead, the original 
% Matlab adftest is chosen due to its ease of use.


%% WIPE
%wipe the memory

clear all
close all
clc


%%
%This code is used to read data from various excel forms.

%///CHANGE EXCEL DATE FORMAT TO GENERAL, NOT STRING///

%This is for importing from Yahoo Finance.
%[SZ_orig,~,~]       = xlsread('C:\thesis\market2.xlsx','Sheet1');
%SZtime_orig         = SZ_orig(7:end,1:1);
%SZprice_orig        = SZ_orig(7:end,7:7);

%This is for importing from Datastream. note this reads .xls, not .xlsx
%US RE Market = Down Jones = DJ
[DJ_orig,~,~]       = xlsread('C:\thesis\market1.xlsx','Sheet1');
DJtime_orig         = DJ_orig(7:end,1:1);
DJprice_orig        = DJ_orig(7:end,2:2);
%China RE Market = Shenzhen = SZ
[SZ_orig,~,~]       = xlsread('C:\thesis\market2.xlsx','Sheet1');
SZtime_orig         = SZ_orig(7:end,1:1);
SZprice_orig        = SZ_orig(7:end,2:2);


%%
%Datastream #N/A entries become NaN in Matlab. must remove NaN for
%ARMAXfilter and GARCH functions

%Create ID columns. 0 appears where NaN
DJ_IDp                              = (1-isnan(DJprice_orig));
SZ_IDp                              = (1-isnan(SZprice_orig));

%Apply the time filter by multiplying the ID matrix by time.
%time starts with real numbers, so method 1.
DJtime_orig                         = DJ_IDp.*DJtime_orig;
SZtime_orig                         = SZ_IDp.*SZtime_orig;

%price starts with not a number (NaN), so method 2.
%dimension trouble
DJprice_orig(isnan(DJprice_orig))   = 0;
SZprice_orig(isnan(SZprice_orig))   = 0;

%remove the zeros. NaNs must have been replaced by 0s for this to work.
DJtime_orig                         = DJtime_orig(DJtime_orig~=0);
DJprice_orig                        = DJprice_orig(DJprice_orig~=0);
SZtime_orig                         = SZtime_orig(SZtime_orig~=0);
SZprice_orig                        = SZprice_orig(SZprice_orig~=0);


%%
%Filter out uncommon trading days
%Create a filter

%Create ID columns. 0 appears when the other market was not trading.
%US RE Market
DJ_IDt          = ismember(DJtime_orig,SZtime_orig);
%China RE Market
SZ_IDt          = ismember(SZtime_orig,DJtime_orig);

%Apply the filter by multiplying the ID matrix by time and price.
%US RE Market
DJtime          = DJ_IDt.*DJtime_orig;
DJprice         = DJ_IDt.*DJprice_orig;
%China RE Market
SZtime          = SZ_IDt.*SZtime_orig;
SZprice         = SZ_IDt.*SZprice_orig;


%%
%Remove zeros

%Overlap
%US RE Market
DJtime      = DJtime(DJtime~=0);
DJprice     = DJprice(DJprice~=0);
%China RE Market
SZtime      = SZtime(SZtime~=0);
SZprice     = SZprice(SZprice~=0);


%%
%Combine dates and prices into 1 matrix

%US RE Market
DJmatrix    = [DJtime,DJprice];
%China RE Market
SZmatrix    = [SZtime,SZprice];


%% CALCULATE PRICE STATS
%

DJprice_orig_n          = length(DJprice_orig);
DJprice_orig_mean       = mean(DJprice_orig);
DJprice_orig_median     = median(DJprice_orig);
DJprice_orig_min        = min(DJprice_orig);
DJprice_orig_max        = max(DJprice_orig);
DJprice_orig_std        = std(DJprice_orig);
DJprice_orig_skew       = skewness(DJprice_orig);
DJprice_orig_kurt       = kurtosis(DJprice_orig);
DJstats_orig            = [DJprice_orig_n; DJprice_orig_mean; DJprice_orig_median; DJprice_orig_min; DJprice_orig_max; DJprice_orig_std; DJprice_orig_skew; DJprice_orig_kurt];

DJprice_n               = length(DJprice);
DJprice_mean            = mean(DJprice);
DJprice_median          = median(DJprice);
DJprice_min             = min(DJprice);
DJprice_max             = max(DJprice);
DJprice_std             = std(DJprice);
DJprice_skew            = skewness(DJprice);
DJprice_kurt            = kurtosis(DJprice);
DJstats                 = [DJprice_n; DJprice_mean; DJprice_median; DJprice_min; DJprice_max; DJprice_std; DJprice_skew; DJprice_kurt];

SZprice_orig_n          = length(SZprice_orig);
SZprice_orig_mean       = mean(SZprice_orig);
SZprice_orig_median     = median(SZprice_orig);
SZprice_orig_min        = min(SZprice_orig);
SZprice_orig_max        = max(SZprice_orig);
SZprice_orig_std        = std(SZprice_orig);
SZprice_orig_skew       = skewness(SZprice_orig);
SZprice_orig_kurt       = kurtosis(SZprice_orig);
SZstats_orig            = [SZprice_orig_n; SZprice_orig_mean; SZprice_orig_median; SZprice_orig_min; SZprice_orig_max; SZprice_orig_std; SZprice_orig_skew; SZprice_orig_kurt];

SZprice_n               = length(SZprice);
SZprice_mean            = mean(SZprice);
SZprice_median          = median(SZprice);
SZprice_min             = min(SZprice);
SZprice_max             = max(SZprice);
SZprice_std             = std(SZprice);
SZprice_skew            = skewness(SZprice);
SZprice_kurt            = kurtosis(SZprice);
SZstats                 = [SZprice_n; SZprice_mean; SZprice_median; SZprice_min; SZprice_max; SZprice_std; SZprice_skew; SZprice_kurt];


%% WRITE STATS
%

%Write statistics summary to excel file.

%Original matrix
xlswrite('C:\thesis\stats.xlsx',DJstats_orig,'price','C4');
xlswrite('C:\thesis\stats.xlsx',SZstats_orig,'price','D4');

%Overlap matrix
xlswrite('C:\thesis\stats.xlsx',DJstats,'price','G4');
xlswrite('C:\thesis\stats.xlsx',SZstats,'price','H4');

%US RE Market matrix
xlswrite('C:\thesis\stats.xlsx',DJstats_orig,'price','C15');
xlswrite('C:\thesis\stats.xlsx',DJstats,'price','D15');

%China RE Market matrix
xlswrite('C:\thesis\stats.xlsx',SZstats_orig,'price','G15');
xlswrite('C:\thesis\stats.xlsx',SZstats,'price','H15');




%% CHECK FOR AUTOCORRELATION OF PRICES
%Compute and plot the Autocorrelation Function on prices

figure
subplot(2,1,1)
autocorr(DJprice)
title('Autocorrelation Function on DJ Prices')

subplot(2,1,2)
autocorr(SZprice)
title('Autocorrelation Function on SZ Prices')

%Every data point is perfectly correlated with itself.

%%
%===========================================================================================
%===========================================================================================

%% UNIT ROOT TEST 1
%check price series for stationarity with dickey-fuller test.

%maybe i should do log price????
% 
% % default alpha = 0.05
%  [adf_DJprice_h,adf_DJprice_pValue,adf_DJprice_stat,adf_DJprice_crit,~] ...
%      = adftest(DJprice,'lags',1);
% % 
%  [adf_SZprice_h,adf_SZprice_pValue,adf_SZprice_stat,adf_SZprice_crit,~] ...
%      = adftest(SZprice,'lags',1);


%% PRINT RESULTS
%
%  
% clc
%  fprintf('Perform a unit-root test to determine if the time series')
%  fprintf(' is stationary.\n')
%  fprintf('H0 indicates the time series is non-stationary I(1).\n')
%  fprintf('H1 indicates the time series is stationary I(0).\n\n')
%  
%  fprintf('If the test-statistic is greater than the critical value,')
%  fprintf(' then we \ncannot reject H0. Lower p-values indicate greater')
%  fprintf(' likelihood.\n\n')
%  
%  fprintf('Using the augmented Dickey-Fuller test...\n\n')
%  
%  fprintf('++Test DJprice++ \n')
%  fprintf('The test-statistic is %1.1d\n', adf_DJprice_stat)
%  fprintf('The critical value is %1.1d\n', adf_DJprice_crit)
%  fprintf('The p-value is %1.1d\n', adf_DJprice_pValue)
%  fprintf('Therefore, go with H%1.1d\n\n', adf_DJprice_h)
%  
%  fprintf('++Test SZprice++ \n')
%  fprintf('The test-statistic is %1.1d\n', adf_SZprice_stat)
%  fprintf('The critical value is %1.1d\n', adf_SZprice_crit)
%  fprintf('The p-value is %1.1d\n', adf_SZprice_pValue)
%  fprintf('Therefore, go with H%1.1d\n\n', adf_SZprice_h)


%% RETURNS
%obtain log returns from prices

%Original observations
%US RE Market
DJreturn_orig       = price2ret(DJprice_orig);
%US RE Market
SZreturn_orig       = price2ret(SZprice_orig);

%Overlap observations
DJreturn            = price2ret(DJprice);
%SP500return        = price2ret(SP500price);
SZreturn            = price2ret(SZprice);
%SZSEreturn         = price2ret(SZSEprice);


%% CALCULATE RETURN STATS
%
 
DJreturn_orig_n          = length(DJreturn_orig);
DJreturn_orig_mean       = mean(DJreturn_orig);
DJreturn_orig_median     = median(DJreturn_orig);
DJreturn_orig_min        = min(DJreturn_orig);
DJreturn_orig_max        = max(DJreturn_orig);
DJreturn_orig_std        = std(DJreturn_orig);
DJreturn_orig_skew       = skewness(DJreturn_orig);
DJreturn_orig_kurt       = kurtosis(DJreturn_orig);
DJstats_orig             = [DJreturn_orig_n; DJreturn_orig_mean; DJreturn_orig_median; DJreturn_orig_min; DJreturn_orig_max; DJreturn_orig_std; DJreturn_orig_skew; DJreturn_orig_kurt];
 
DJreturn_n               = length(DJreturn);
DJreturn_mean            = mean(DJreturn);
DJreturn_median          = median(DJreturn);
DJreturn_min             = min(DJreturn);
DJreturn_max             = max(DJreturn);
DJreturn_std             = std(DJreturn);
DJreturn_skew            = skewness(DJreturn);
DJreturn_kurt            = kurtosis(DJreturn);
DJstats                  = [DJreturn_n; DJreturn_mean; DJreturn_median; DJreturn_min; DJreturn_max; DJreturn_std; DJreturn_skew; DJreturn_kurt];
 
SZreturn_orig_n          = length(SZreturn_orig);
SZreturn_orig_mean       = mean(SZreturn_orig);
SZreturn_orig_median     = median(SZreturn_orig);
SZreturn_orig_min        = min(SZreturn_orig);
SZreturn_orig_max        = max(SZreturn_orig);
SZreturn_orig_std        = std(SZreturn_orig);
SZreturn_orig_skew       = skewness(SZreturn_orig);
SZreturn_orig_kurt       = kurtosis(SZreturn_orig);
SZstats_orig             = [SZreturn_orig_n; SZreturn_orig_mean; SZreturn_orig_median; SZreturn_orig_min; SZreturn_orig_max; SZreturn_orig_std; SZreturn_orig_skew; SZreturn_orig_kurt];
%  jbtest
SZreturn_n               = length(SZreturn);
SZreturn_mean            = mean(SZreturn);
SZreturn_median          = median(SZreturn);
SZreturn_min             = min(SZreturn);
SZreturn_max             = max(SZreturn);
SZreturn_std             = std(SZreturn);
SZreturn_skew            = skewness(SZreturn);
SZreturn_kurt            = kurtosis(SZreturn);
SZstats                  = [SZreturn_n; SZreturn_mean; SZreturn_median; SZreturn_min; SZreturn_max; SZreturn_std; SZreturn_skew; SZreturn_kurt];
 
 
%% UNCONDITIONAL CORRELATION
% check the unconditional correlation between the two market returns seres.

corrboth = corr(DJreturn, SZreturn);


%% WRITE RETURN STATS
%
 
%Write statistics summary to excel file.
 
%Original matrix
xlswrite('C:\thesis\stats.xlsx',DJstats_orig,'return','C4');
xlswrite('C:\thesis\stats.xlsx',SZstats_orig,'return','D4');
 
%Overlap matrix
xlswrite('C:\thesis\stats.xlsx',DJstats,'return','G4');
xlswrite('C:\thesis\stats.xlsx',SZstats,'return','H4');
 
%US RE Market matrix
xlswrite('C:\thesis\stats.xlsx',DJstats_orig,'return','C15');
xlswrite('C:\thesis\stats.xlsx',DJstats,'return','D15');
 
%China RE Market matrix
xlswrite('C:\thesis\stats.xlsx',SZstats_orig,'return','G15');
xlswrite('C:\thesis\stats.xlsx',SZstats,'return','H15');

%Market both
xlswrite('C:\thesis\stats.xlsx',corrboth,'GARCH','D32');

%%
% PLOT PRICE HISTOGRAM

% Set 100 bins.
figure
subplot(2,1,1)
histfit(DJreturn,100);
figure(gcf);
ylabel('# Observations')
xlabel('Returns')
title('DJ Return Distribution')
hold

subplot(2,1,2)
histfit(SZreturn,100);
figure(gcf);
ylabel('# Observations')
xlabel('Returns')
title('SZ Return Distribution')


%% OVERLAPPING KERNEL DENSITY FUNCTIONS
% This graph is used purely as a visual aid.

figure;
ksdensity(DJreturn);
hold all;
ksdensity(SZreturn);
legend('DJ','SZ','Location','NorthEast');
ylabel('# Observations')
xlabel('Returns')
title('Comparison of Smoothed Distributions')


%% CHECK FOR AUTOCORRELATION OF RETURNS
%Compute and plot the squared returns Autocorrelation Function and Partial ACF

figure
subplot(2,1,1)
autocorr(DJreturn.^2)
title('Autocorrelation Function on DJ Returns^2')

subplot(2,1,2)
autocorr(SZreturn.^2)
title('Autocorrelation Function on SZ Returns^2')

%There is considerable correlation in the data. This reveals the need for
%a conditional variance model with MA and AR terms.


%% STANDARD DEVIATION CHECK PRE-ESTIMATION
%compute standard deviations for later comparison

%Original observations
Std_DJ_orig         = std(DJreturn_orig(:))*sqrt(250);
Std_SZ_orig         = std(SZreturn_orig(:))*sqrt(250);

%Overlap observations
Std_DJ              = std(DJreturn(:))*sqrt(250);
%Std_sp500          = std(SP500return(:))*sqrt(250);
Std_SZ              = std(SZreturn(:))*sqrt(250);
%Std_szse           = std(SZSEreturn(:))*sqrt(250);

%Check Std_*. everything look ok? good.
%Compare this to the data without common trading day filter


%% UNIT ROOT TEST 2
%check returns for stationarity with dickey-fuller test. this model is AR,
%or no constant or trend. there is also ARD (c) and TS (trend and c).
 

%default alpha = 0.05
%  [adf_DJreturn_h,adf_DJreturn_pValue,adf_DJreturn_stat,adf_DJreturn_crit,~] ...
%      = adftest(DJreturn,'lags',1);
%  
%  [adf_SZreturn_h,adf_SZreturn_pValue,adf_SZreturn_stat,adf_SZreturn_crit,~] ...
%      = adftest(SZreturn,'lags',1);
 
% adf_DJreturn = adf(DJreturn,0,1);
% adf_SZreturn = adf(DJreturn,0,1);


%% PRINT RESULTS
%

%  clc
%  fprintf('Perform a unit-root test to determine if the time series')
%  fprintf(' is stationary.\n')
%  fprintf('H0 indicates the time series is non-stationary I(1).\n')
%  fprintf('H1 indicates the time series is stationary I(0).\n\n')
%  
%  fprintf('If the test-statistic is greater than the critical value,')
%  fprintf(' then we \ncannot reject H0. Lower p-values indicate greater')
%  fprintf(' likelihood.\n\n')
%  
%  fprintf('Using the augmented Dickey-Fuller test...\n\n')
%  
%  fprintf('++Test DJreturn++ \n')
%  fprintf('The test-statistic is %1.1d\n', adf_DJreturn_stat)
%  fprintf('The critical value is %1.1d\n', adf_DJreturn_crit)
%  fprintf('The p-value is %1.1d\n', adf_DJreturn_pValue)
%  fprintf('Therefore, go with H%1.1d\n\n', adf_DJreturn_h)
%  
%  fprintf('++Test SZreturn++ \n')
%  fprintf('The test-statistic is %1.1d\n', adf_SZreturn_stat)
%  fprintf('The critical value is %1.1d\n', adf_SZreturn_crit)
%  fprintf('The p-value is %1.1d\n', adf_SZreturn_pValue)
%  fprintf('Therefore, go with H%1.1d\n\n', adf_SZreturn_h)
 
 %adf_DJprice = adf(DJprice,0,1);
 %adf_SZprice = adf(SZprice,0,1);
 %this is crazy hard. move back to default adf test.


%% ARMA filter
%The conditional mean needs to be extracted so that the error process is
%white noise. After this, the GARCH conditional variance can be better
%analyzed.

%Pull out the conditional mean with ARMA. 

% [1parameters, 2errors, 3LLF , 4SEregression, 5stderrors, 6robustSE, 7scores, 9likelihoods]=

%Original observations
[ARMAparamsDJ_orig,ARMAerrorsDJ_orig,~,ARMAsterrorsDJ_orig,~,~,~,~]           = armaxfilter(DJreturn_orig,1,1,1);
[ARMAparamsSZ_orig,ARMAerrorsSZ_orig,~,ARMAsterrorsSZ_orig,~,~,~,~]           = armaxfilter(SZreturn_orig,1,1,1);

%Overlap observations
[ARMAparamsDJ,ARMAerrorsDJ,~,ARMAsterrorsDJ,~,~,~,~]           = armaxfilter(DJreturn,1,1,1);
%[~,ARMAerrorssp500,~,~,~,~,~,~]            = armaxfilter(SP500return,1,1,1);
[ARMAparamsSZ,ARMAerrorsSZ,~,ARMAsterrorsSZ,~,~,~,~]           = armaxfilter(SZreturn,1,1,1);
%[~,ARMAerrorsszse,~,~,~,~,~,~]             = armaxfilter(SZSEreturn,1,1,1);

%% LAGRANGE MULTIPLIER
%Should perform Lagrange multiplier test (lmtest), but a visual check will
%suffice. Or will it? This could be a hole.

%%
% Square the ARMA residuals to find market shock, or volatilities of
% returns

ARMAmarketshockDJ = (ARMAerrorsDJ).*(ARMAerrorsDJ);
ARMAmarketshockSZ = (ARMAerrorsSZ).*(ARMAerrorsSZ);


figure
subplot(2,1,1)
plot(ARMAmarketshockDJ,'r')
% axis([0 3000 0 0.06]) 
ylabel('Market shock DJ')
title('DJ Overlap Oberservations')


subplot(2,1,2)
plot(ARMAmarketshockSZ,'b')
% axis([0 3000 0 0.06]) 
ylabel('Market shock SZ')
title('SZ Overlap Oberservations')


%%
%Check the resultant numbers.

ARMAstdDJ_orig          = std(ARMAerrorsDJ_orig);
ARMAstdDJ               = std(ARMAerrorsDJ);
ARMAstdSZ_orig          = std(ARMAerrorsSZ_orig);
ARMAstdSZ               = std(ARMAerrorsSZ_orig);
%should get LT variance near these somewhere

ARMAsquaredDJ_orig      = (ARMAerrorsDJ_orig).^2;
ARMAsquaredDJ           = (ARMAerrorsDJ).^2;
ARMAsquaredSZ_orig      = (ARMAerrorsSZ_orig).^2;
ARMAsquaredSZ           = (ARMAerrorsSZ).^2;

%ARMA parameters
ARMAconstantDJ          = ARMAparamsDJ(1,1);
ARMAARDJ                = ARMAparamsDJ(1,2);
ARMAMADJ                = ARMAparamsDJ(1,3);

ARMAconstantSZ          = ARMAparamsSZ(1,1);
ARMAARSZ                = ARMAparamsSZ(1,2);
ARMAMASZ                = ARMAparamsSZ(1,3);

%ARMA parameters t-ratios
ARMAconstanttratioDJ    = ARMAconstantDJ/ARMAsterrorsDJ;
ARMAARtratioDJ          = ARMAARDJ/ARMAsterrorsDJ;
ARMAMAtratioDJ          = ARMAMADJ/ARMAsterrorsDJ;

ARMAconstanttratioSZ    = ARMAconstantSZ/ARMAsterrorsSZ;
ARMAARtratioSZ          = ARMAARSZ/ARMAsterrorsSZ;
ARMAMAtratioSZ          = ARMAMASZ/ARMAsterrorsSZ;


%% WRITE ARMA PARAMS, T-RATIOS
%

%DJ
xlswrite('C:\thesis\stats.xlsx',ARMAconstantDJ,'ARMA','C4');
xlswrite('C:\thesis\stats.xlsx',ARMAARDJ,'ARMA','C5');
xlswrite('C:\thesis\stats.xlsx',ARMAMADJ,'ARMA','C6');

%SZ
xlswrite('C:\thesis\stats.xlsx',ARMAconstantSZ,'ARMA','E4');
xlswrite('C:\thesis\stats.xlsx',ARMAARSZ,'ARMA','E5');
xlswrite('C:\thesis\stats.xlsx',ARMAMASZ,'ARMA','E6');

%DJ t-ratio
xlswrite('C:\thesis\stats.xlsx',ARMAconstanttratioDJ,'ARMA','D4');
xlswrite('C:\thesis\stats.xlsx',ARMAARtratioDJ,'ARMA','D5');
xlswrite('C:\thesis\stats.xlsx',ARMAMAtratioDJ,'ARMA','D6');

%SZ t-ratio
xlswrite('C:\thesis\stats.xlsx',ARMAconstanttratioSZ,'ARMA','F4');
xlswrite('C:\thesis\stats.xlsx',ARMAARtratioSZ,'ARMA','F5');
xlswrite('C:\thesis\stats.xlsx',ARMAMAtratioSZ,'ARMA','F6');



%% GARCH
%Using the residuals from the ARMA model, estimate GARCH parameters.
%Parameters are estimated using Levenberg-Marquardt algorithm (I.5.4.3)

%Pull out the conditional variance with GARCH.

%Original observations
[GARCHpqparametersDJ_orig,GARCHpqmaxliklihoodDJ_orig,GARCHpgvariancesDJ_orig,GARCHpgstderrorDJ_orig,GARCHpgscoresDJ_orig,~]     = garchpq(ARMAerrorsDJ_orig,1,1);
[GARCHpqparametersSZ_orig,GARCHpqmaxliklihoodSZ_orig,GARCHpgvariancesSZ_orig,GARCHpgstderrorSZ_orig,GARCHpgscoresSZ_orig,~]     = garchpq(ARMAerrorsSZ_orig,1,1);

%Overlap observations
[GARCHpqparametersDJ,GARCHpqmaxliklihoodDJ,GARCHpgvariancesDJ,GARCHpgstderrorDJ,GARCHpgscoresDJ,~]                              = garchpq(ARMAerrorsDJ,1,1);
[GARCHpqparametersSZ,GARCHpqmaxliklihoodSZ,GARCHpgvariancesSZ,GARCHpgstderrorSZ,GARCHpgscoresSZ,~]                              = garchpq(ARMAerrorsSZ,1,1);

%GARCH Standard Deviation check
std_GARCHDJ_orig                    = std(GARCHpgvariancesDJ_orig);
std_GARCHDJ                         = std(GARCHpgvariancesDJ);
std_GARCHSZ_orig                    = std(GARCHpgvariancesSZ_orig);
std_GARCHSZ                         = std(GARCHpgvariancesSZ_orig);

%GARCH Conditional Standard Deviations (for plotting)
GARCHpgcondstdDJ_orig               = sqrt(GARCHpgvariancesDJ_orig);
GARCHpgcondstdDJ                    = sqrt(GARCHpgvariancesDJ);
GARCHpgcondstdSZ_orig               = sqrt(GARCHpgvariancesSZ_orig);
GARCHpgcondstdSZ                    = sqrt(GARCHpgvariancesSZ);

%GARCH Conditional Volatility (for plotting)
GARCHpgcondvolDJ_orig               = sqrt(GARCHpgvariancesDJ_orig*250);
GARCHpgcondvolDJ                    = sqrt(GARCHpgvariancesDJ*250);
GARCHpgcondvolSZ_orig               = sqrt(GARCHpgvariancesSZ_orig*250);
GARCHpgcondvolSZ                    = sqrt(GARCHpgvariancesSZ*250);

%Compute the t-test values
GARCHpqparameters_w_ttestDJ_orig    = GARCHpqparametersDJ_orig(1,1) / GARCHpgstderrorDJ_orig(1,1);
GARCHpqparameters_a_ttestDJ_orig    = GARCHpqparametersDJ_orig(2,1) / GARCHpgstderrorDJ_orig(2,2);
GARCHpqparameters_b_ttestDJ_orig    = GARCHpqparametersDJ_orig(3,1) / GARCHpgstderrorDJ_orig(3,3);
GARCHpqparameters_ttestDJ_orig      = [GARCHpqparameters_w_ttestDJ_orig; GARCHpqparameters_a_ttestDJ_orig; GARCHpqparameters_b_ttestDJ_orig];

GARCHpqparameters_w_ttestDJ         = GARCHpqparametersDJ(1,1) / GARCHpgstderrorDJ(1,1);
GARCHpqparameters_a_ttestDJ         = GARCHpqparametersDJ(2,1) / GARCHpgstderrorDJ(2,2);
GARCHpqparameters_b_ttestDJ         = GARCHpqparametersDJ(3,1) / GARCHpgstderrorDJ(3,3);
GARCHpqparameters_ttestDJ           = [GARCHpqparameters_w_ttestDJ; GARCHpqparameters_a_ttestDJ; GARCHpqparameters_b_ttestDJ];

GARCHpqparameters_w_ttestSZ_orig    = GARCHpqparametersSZ_orig(1,1) / GARCHpgstderrorSZ_orig(1,1);
GARCHpqparameters_a_ttestSZ_orig    = GARCHpqparametersSZ_orig(2,1) / GARCHpgstderrorSZ_orig(2,2);
GARCHpqparameters_b_ttestSZ_orig    = GARCHpqparametersSZ_orig(3,1) / GARCHpgstderrorSZ_orig(3,3);
GARCHpqparameters_ttestSZ_orig      = [GARCHpqparameters_w_ttestSZ_orig; GARCHpqparameters_a_ttestSZ_orig; GARCHpqparameters_b_ttestSZ_orig];

GARCHpqparameters_w_ttestSZ         = GARCHpqparametersSZ(1,1) / GARCHpgstderrorSZ(1,1);
GARCHpqparameters_a_ttestSZ         = GARCHpqparametersSZ(2,1) / GARCHpgstderrorSZ(2,2);
GARCHpqparameters_b_ttestSZ         = GARCHpqparametersSZ(3,1) / GARCHpgstderrorSZ(3,3);
GARCHpqparameters_ttestSZ           = [GARCHpqparameters_w_ttestSZ; GARCHpqparameters_a_ttestSZ; GARCHpqparameters_b_ttestSZ];


%% VOLATILITY CHECK UNIVARIATE GARCH
%check that volatility makes sense given parameters

%Original observations
%define parameters w a b
p_DJ_w_orig                 = GARCHpqparametersDJ_orig(1,1);
p_DJ_a_orig                 = GARCHpqparametersDJ_orig(2,1);
p_DJ_b_orig                 = GARCHpqparametersDJ_orig(3,1);
p_DJ_mle_orig               = GARCHpqmaxliklihoodDJ_orig;

% sqrt(250*(w / ((1 - (a + b))))
Vol_LT_GARCH_DJ_orig        = sqrt((250)*(p_DJ_w_orig)/(1-(p_DJ_a_orig+p_DJ_b_orig)));
p_DJ_EstMeanLagVar_orig     = 1/(1-p_DJ_b_orig);
p_DJ_orig                   = [p_DJ_w_orig; p_DJ_a_orig; p_DJ_b_orig; Vol_LT_GARCH_DJ_orig; p_DJ_EstMeanLagVar_orig; p_DJ_mle_orig];

%define parameters w a b
p_SZ_w_orig                 = GARCHpqparametersSZ_orig(1,1);
p_SZ_a_orig                 = GARCHpqparametersSZ_orig(2,1);
p_SZ_b_orig                 = GARCHpqparametersSZ_orig(3,1);
p_SZ_mle_orig               = GARCHpqmaxliklihoodSZ_orig;

% sqrt(250*(w / ((1 - (a + b))))
Vol_LT_GARCH_SZ_orig        = sqrt((250)*(p_SZ_w_orig)/(1-(p_SZ_a_orig+p_SZ_b_orig)));
p_SZ_EstMeanLagVar_orig     = 1/(1-p_SZ_b_orig);
p_SZ_orig                   = [p_SZ_w_orig; p_SZ_a_orig; p_SZ_b_orig; Vol_LT_GARCH_SZ_orig; p_SZ_EstMeanLagVar_orig; p_SZ_mle_orig];

%Overlap observations
%define parameters w a b
p_DJ_w                      = GARCHpqparametersDJ(1,1);
p_DJ_a                      = GARCHpqparametersDJ(2,1);
p_DJ_b                      = GARCHpqparametersDJ(3,1);
p_DJ_mle                    = GARCHpqmaxliklihoodDJ;

% sqrt(250*(w / ((1 - (a + b))))
Vol_LT_GARCH_DJ             = sqrt((250)*(p_DJ_w)/(1-(p_DJ_a+p_DJ_b)));
p_DJ_EstMeanLagVar          = 1/(1-p_DJ_b);
p_DJ                        = [p_DJ_w; p_DJ_a; p_DJ_b; Vol_LT_GARCH_DJ; p_DJ_EstMeanLagVar; p_DJ_mle];

%define parameters w a b
p_SZ_w                      = GARCHpqparametersSZ(1,1);
p_SZ_a                      = GARCHpqparametersSZ(2,1);
p_SZ_b                      = GARCHpqparametersSZ(3,1);
p_SZ_mle                    = GARCHpqmaxliklihoodSZ;

% sqrt(250*(w / ((1 - (a + b))))
Vol_LT_GARCH_SZ             = sqrt((250)*(p_SZ_w)/(1-(p_SZ_a+p_SZ_b)));
p_SZ_EstMeanLagVar          = 1/(1-p_SZ_b);
p_SZ                        = [p_SZ_w; p_SZ_a; p_SZ_b; Vol_LT_GARCH_SZ; p_SZ_EstMeanLagVar; p_SZ_mle];


%% EWMA Covariance
%Calculate EWMA to use in upcoming MV-GARCH section.

%Write prices excel file
%US RE Market
xlswrite('C:\thesis\EWMA.xlsx',DJprice,'market1');
%China RE Market
xlswrite('C:\thesis\EWMA.xlsx',SZprice,'market2');

%Read EWMA computations from excel. 
%NOTE: Choose EWMA weighting in excel file sheet1. Default = 0.95 and 0.97

%These are only read for possible usage. They are used to compute EWMA
%covariance, which is calculated in Excel.

%US RE Market
[EWMADJ,~,~]                = xlsread('C:\thesis\EWMA.xlsx','market1');
EWMADJstand95               = EWMADJ(2:end,7:7);
EWMADJstand97               = EWMADJ(2:end,10:10);

%Read EWMA computations from excel
%China RE Market
[EWMASZ,~,~]                = xlsread('C:\thesis\EWMA.xlsx','market2');
EWMASZstand95               = EWMASZ(2:end,7:7);
EWMASZstand97               = EWMASZ(2:end,10:10);

%Read EWMA covariance
[EWMAcov,~,~]               = xlsread('C:\thesis\EWMA.xlsx','EWMAcov');
EWMAcov95                   = EWMAcov(2:end,4:4);
EWMAcov97                   = EWMAcov(2:end,8:8);


%% MVGARCH COMBINE VECTORS
%Only executable for overlap observations

%Prepare an MVGARCH matrix from the ARMA errors for CC-GARCH
both         = [ARMAerrorsDJ,ARMAerrorsSZ];


%% MVGARCH CALCULATE
%Only executable for overlap observations

%CC-GARCH
[CCparameters,CClogliklihood,CCR,CCCondVar,~,~,~,~,CCstderror,~,~,~]  = cc_mvgarch(both,1,1);

%DCC-GARCH
DCC_GARCH_Cov95     = GARCHpgcondvolDJ.*GARCHpgcondvolSZ.*EWMAcov95;
DCC_GARCH_Cov97     = GARCHpgcondvolDJ.*GARCHpgcondvolSZ.*EWMAcov97;


%% STATS CHECK MV-GARCH
%

%Identify parameters
MVGARCHpqparameters_r       = CCparameters(7,1); 

MVGARCHpqparameters_w_DJ    = CCparameters(1,1); 
MVGARCHpqparameters_a_DJ    = CCparameters(2,1); 
MVGARCHpqparameters_b_DJ    = CCparameters(3,1); 
Vol_LT_MVGARCH_DJ           = sqrt((250)*(MVGARCHpqparameters_w_DJ)/(1-(MVGARCHpqparameters_a_DJ+MVGARCHpqparameters_b_DJ)));
p_DJ_LTEstMeanLagVar        = 1/(1-MVGARCHpqparameters_b_DJ);
MVGARCHpqparameters_mle_DJ  = CClogliklihood;
MVGARCHpqparameters_r_DJ    = MVGARCHpqparameters_r;
MVGARCHpqparameters_DJ      = [MVGARCHpqparameters_w_DJ; MVGARCHpqparameters_a_DJ; MVGARCHpqparameters_b_DJ; Vol_LT_MVGARCH_DJ; p_DJ_LTEstMeanLagVar; MVGARCHpqparameters_mle_DJ; MVGARCHpqparameters_r_DJ];

MVGARCHpqparameters_w_SZ    = CCparameters(4,1); 
MVGARCHpqparameters_a_SZ    = CCparameters(5,1); 
MVGARCHpqparameters_b_SZ    = CCparameters(6,1); 
Vol_LT_MVGARCH_SZ           = sqrt((250)*(MVGARCHpqparameters_w_SZ)/(1-(MVGARCHpqparameters_a_SZ+MVGARCHpqparameters_b_SZ)));
p_SZ_LTEstMeanLagVar        = 1/(1-MVGARCHpqparameters_b_SZ);
MVGARCHpqparameters_mle_SZ  = CClogliklihood;
MVGARCHpqparameters_r_SZ    = MVGARCHpqparameters_r;
MVGARCHpqparameters_SZ      = [MVGARCHpqparameters_w_SZ; MVGARCHpqparameters_a_SZ; MVGARCHpqparameters_b_SZ; Vol_LT_MVGARCH_SZ; p_SZ_LTEstMeanLagVar; MVGARCHpqparameters_mle_SZ; MVGARCHpqparameters_r_SZ];


%Identify std errors
MVGARCHpqstderror_w_DJ      = CCstderror(1,1); 
MVGARCHpqstderror_a_DJ      = CCstderror(2,2); 
MVGARCHpqstderror_b_DJ      = CCstderror(3,3); 

MVGARCHpqstderror_w_SZ      = CCstderror(4,4); 
MVGARCHpqstderror_a_SZ      = CCstderror(5,5); 
MVGARCHpqstderror_b_SZ      = CCstderror(6,6); 
MVGARCHpqstderror_r         = CCstderror(7,7); 

%Compute t-stats
MVGARCHpq_w_ttest_DJ        = MVGARCHpqparameters_w_DJ / MVGARCHpqstderror_w_DJ;
MVGARCHpq_a_ttest_DJ        = MVGARCHpqparameters_a_DJ / MVGARCHpqstderror_a_DJ;
MVGARCHpq_b_ttest_DJ        = MVGARCHpqparameters_b_DJ / MVGARCHpqstderror_b_DJ;
MVGARCHpq_ttest_r_DJ        = MVGARCHpqparameters_r / MVGARCHpqstderror_r;
MVGARCHpq_ttest_DJ          = [MVGARCHpq_w_ttest_DJ; MVGARCHpq_a_ttest_DJ; MVGARCHpq_b_ttest_DJ];


MVGARCHpq_w_ttest_SZ        = MVGARCHpqparameters_w_SZ / MVGARCHpqstderror_w_SZ;
MVGARCHpq_a_ttest_SZ        = MVGARCHpqparameters_a_SZ / MVGARCHpqstderror_a_SZ;
MVGARCHpq_b_ttest_SZ        = MVGARCHpqparameters_b_SZ / MVGARCHpqstderror_b_SZ;
MVGARCHpq_ttest_r_SZ        = MVGARCHpqparameters_r / MVGARCHpqstderror_r;
MVGARCHpq_ttest_SZ          = [MVGARCHpq_w_ttest_SZ; MVGARCHpq_a_ttest_SZ; MVGARCHpq_b_ttest_SZ];

% MVGARCHpq_ttest_r           = MVGARCHpqparameters_r / MVGARCHpqstderror_r;

% GARCHpqparameters_w_ttestDJ_orig    = GARCHpqparametersDJ_orig(1,1) / GARCHpgstderrorDJ_orig(1,1);
% GARCHpqparameters_ttestDJ_orig      = [GARCHpqparameters_w_ttestDJ_orig; GARCHpqparameters_a_ttestDJ_orig; GARCHpqparameters_b_ttestDJ_orig];

%Volatility
Vol_LT_MVGARCH_DJ           = sqrt((250)*(CCparameters(1,1)/(1-CCparameters(2,1)+CCparameters(3,1))));
Vol_LT_MVGARCH_SZ           = sqrt((250)*(CCparameters(4,1)/(1-CCparameters(5,1)+CCparameters(6,1))));

DJ_EstMeanLagVarMV          = 1/(1-CCparameters(3,1));
SZ_EstMeanLagVarMV          = 1/(1-CCparameters(6,1));

%The estimation is too unstable. All that can be done is to bind the two
%univariate GARCH estimations together using the CC and DCC methods.


%% WRITE UNIVARIATE GARCH PARAMS, T-STATS, THEN MULTIVARIATE...
%

%UNIVARIATE
%Original matrix
xlswrite('C:\thesis\stats.xlsx',p_DJ_orig,'GARCH','C4');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestDJ_orig,'GARCH','D4');
xlswrite('C:\thesis\stats.xlsx',p_SZ_orig,'GARCH','E4');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestSZ_orig,'GARCH','F4');

%Overlap matrix
xlswrite('C:\thesis\stats.xlsx',p_DJ,'GARCH','I4');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestDJ,'GARCH','J4');
xlswrite('C:\thesis\stats.xlsx',p_SZ,'GARCH','K4');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestSZ,'GARCH','L4');

%US RE Market matrix
xlswrite('C:\thesis\stats.xlsx',p_DJ_orig,'GARCH','C13');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestDJ_orig,'GARCH','D13');
xlswrite('C:\thesis\stats.xlsx',p_DJ,'GARCH','E13');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestDJ,'GARCH','F13');

%China RE Market matrix
xlswrite('C:\thesis\stats.xlsx',p_SZ_orig,'GARCH','I13');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestSZ_orig,'GARCH','J13');
xlswrite('C:\thesis\stats.xlsx',p_SZ,'GARCH','K13');
xlswrite('C:\thesis\stats.xlsx',GARCHpqparameters_ttestSZ,'GARCH','L13');

%MULTIVARIATE
xlswrite('C:\thesis\stats.xlsx',MVGARCHpqparameters_DJ,'GARCH','C22');
xlswrite('C:\thesis\stats.xlsx',MVGARCHpqparameters_mle_DJ,'GARCH','C27');
xlswrite('C:\thesis\stats.xlsx',MVGARCHpq_ttest_DJ,'GARCH','D22');
xlswrite('C:\thesis\stats.xlsx',MVGARCHpq_ttest_r_DJ,'GARCH','D28');

xlswrite('C:\thesis\stats.xlsx',MVGARCHpqparameters_SZ,'GARCH','E22');
xlswrite('C:\thesis\stats.xlsx',MVGARCHpqparameters_mle_SZ,'GARCH','E27');
xlswrite('C:\thesis\stats.xlsx',MVGARCHpq_ttest_SZ,'GARCH','F22');
xlswrite('C:\thesis\stats.xlsx',MVGARCHpq_ttest_r_SZ,'GARCH','F28');



%% ==========================================================================================
%===========================================================================================
%===========================================================================================


%% VISUALS
%Price comparisons

%subplot(2 height, 1 width, placement)
%DJ
figure
subplot(2,1,1)
plot(DJprice,'b')
ylabel('Price')
title('DJ Overlap Oberservations')

%SZ
subplot(2,1,2)
plot(SZprice,'r')
ylabel('Price')
title('SZ Overlap Oberservations')


%%
%Return comparisons

%subplot(2 height, 1 width, placement)
%DJ
figure
%xlabel('Days Since first Observation')
% axis([0 3000 -0.2 0.2]) 
subplot(2,1,1)
plot(DJreturn,'b')
ylabel('Return')
title('DJ Overlap Oberservations')

%SZ
subplot(2,1,2)
plot(SZreturn,'r')
% axis([0 3000 -0.2 0.2]) 
ylabel('Return')
title('SZ Overlap Oberservations')


%%
%ARMA comparisons

%subplot(2 height, 1 width, placement)
%DJ
figure
subplot(2,1,1)
% axis([0 3000 -0.3 0.2]) 
plot(ARMAerrorsDJ,'b')
ylabel('ARMA')
title('DJ Original Oberservations')

%SZ
subplot(2,1,2)
plot(ARMAerrorsSZ,'r')
% axis([0 3000 -0.3 0.2]) 
ylabel('ARMA')
title('SZ Overlap Oberservations')


%%
%GARCH Conditional Variance comparisons

%subplot(2 height, 1 width, placement)
%DJ
figure
subplot(2,1,1)
plot(GARCHpgvariancesDJ,'b')
% axis([0 3000 0 0.012]) 
ylabel('Conditional Variance')
title('DJ Overlap Oberservations')

%SZ
subplot(2,1,2)
plot(GARCHpgvariancesSZ,'r')
% axis([0 3000 0 0.012]) 
ylabel('Conditional Variance')
title('SZ Overlap Oberservations')


%%
%GARCH Conditional Standard Deviation comparisons

%subplot(2 height, 1 width, placement)
figure
subplot(2,1,1)
plot(GARCHpgcondstdDJ,'b')
ylabel('Conditional Std Dev')
title('DJ Overlap Oberservations')

%SZ
subplot(2,1,2)
plot(GARCHpgcondstdSZ,'r')
ylabel('Conditional Std Dev')
title('SZ Overlap Oberservations')

%% CC-GARCH
%
%Plot the GARCH volatilities

figure
plot(GARCHpgcondvolDJ,'b')
hold
plot(GARCHpgcondvolSZ,'r')
legend('DJ','SZ','Location','NorthEast');
ylabel('Volatility %')
xlabel('Days')
title('GARCH Conditional Volatility')


%% DCC-GARCH
%Plot the EWMA covariance time series

figure
plot(EWMAcov95,'r')
legend('0.95','0.97','Location','NorthEast');
ylabel('Standard Deviation')
xlabel('Days')
title('EWMA Standardized Covariances')

%
%Plot the DCC-GARCH time series

figure
plot(DCC_GARCH_Cov95,'r')
legend('0.95','0.97','Location','NorthEast');
ylabel('Volatility %')
xlabel('Days')
title('DCC-GARCH Volatility')


%% PRINT PRICE, ARMA RESULTS
%

clc
fprintf('Did the graphs look ok? Good. Now look at the numbers.\n') 
fprintf('Check standard deviations and volatilities as we run through the models.\n\n') 
fprintf('Press any key to continue\n\n')
pause


fprintf('Looking at the raw original data...\n\n') 
fprintf('DJ original standard deviation is %1.1d\n', Std_DJ_orig)
fprintf('DJ overlap standard deviation is %1.1d\n', Std_DJ)
fprintf('SZ original standard deviation is %1.1d\n', Std_SZ_orig)
fprintf('SZ overlap standard deviation is %1.1d\n\n', Std_SZ)
fprintf('Press any key to continue\n\n')
pause

fprintf('After the ARMA model:\n') 
fprintf('DJ ARMA original standard deviation is %1.1d\n', ARMAstdDJ_orig)
fprintf('DJ ARMA overlap standard deviation is %1.1d\n', ARMAstdDJ)
fprintf('SZ ARMA original standard deviation is %1.1d\n', ARMAstdSZ_orig)
fprintf('SZ ARMA overlap standard deviation is %1.1d\n\n', ARMAstdSZ)
fprintf('Press any key to continue\n\n')
pause


%PRINT UNIVARIATE GARCH PARAMETERS
%

%DJ
fprintf('DJ GARCH original omega estimate is %1.7f.\n', p_DJ_w_orig)
fprintf('Its standard error is %1.9f and ', GARCHpgstderrorDJ_orig(1,1))
fprintf('its t-stat is %1.9f.\n\n', GARCHpgscoresDJ_orig(1,1))

fprintf('DJ GARCH original alpha estimate is %1.7f.\n', p_DJ_a_orig)
fprintf('Its standard error is %1.9f and ', GARCHpgstderrorDJ_orig(2,2))
fprintf('its t-stat is %1.9f.\n\n', GARCHpgscoresDJ_orig(2,2))

fprintf('DJ GARCH original beta estimate is %1.7f.\n', p_DJ_b_orig)
fprintf('Its standard error is %1.9f and ', GARCHpgstderrorDJ_orig(3,3))
fprintf('its t-stat is %1.9f.\n\n\n', GARCHpgscoresDJ_orig(3,3))

%SZ
fprintf('SZ GARCH original omega estimate is %1.7f.\n', p_SZ_w_orig)
fprintf('Its standard error is %1.9f and ', GARCHpgstderrorSZ_orig(1,1))
fprintf('its t-stat is %1.9f.\n\n', GARCHpgscoresSZ_orig(1,1))

fprintf('SZ GARCH original alpha estimate is %1.7f.\n', p_SZ_a_orig)
fprintf('Its standard error is %1.9f and ', GARCHpgstderrorSZ_orig(2,2))
fprintf('its t-stat is %1.9f.\n\n', GARCHpgscoresSZ_orig(2,2))

fprintf('SZ GARCH original beta estimate is %1.7f.\n', p_SZ_b_orig)
fprintf('Its standard error is %1.9f and ', GARCHpgstderrorSZ_orig(3,3))
fprintf('its t-stat is %1.9f.\n\n', GARCHpgscoresSZ_orig(3,3))
fprintf('Press any key to continue\n\n')
pause


% PRINT UNIVARIATE GARCH RESULTS
%

fprintf('After the GARCH model:\n') 
fprintf('DJ GARCH original standard deviation is %1.1d\n', ARMAstdDJ_orig)
fprintf('DJ GARCH overlap standard deviation is %1.1d\n', ARMAstdDJ)
fprintf('SZ GARCH original standard deviation is %1.1d\n', ARMAstdSZ_orig)
fprintf('SZ GARCH overlap standard deviation is %1.1d\n\n', ARMAstdSZ)
fprintf('Press any key to continue\n\n')


fprintf('DJ GARCH original long term volatility estimate is %1.3f%%\n', Vol_LT_GARCH_DJ_orig)
fprintf('DJ GARCH overlap long term volatility estimate is %1.3f%%\n', Vol_LT_GARCH_DJ)
fprintf('SZ GARCH original long term volatility estimate is %1.3f%%\n', Vol_LT_GARCH_SZ_orig)
fprintf('SZ GARCH overlap long term volatility estimate is %1.3f%%\n\n', Vol_LT_GARCH_SZ)
fprintf('Press any key to continue\n\n')
     
fprintf('DJ GARCH original estimated mean lag variance is %1.1f days\n', p_DJ_EstMeanLagVar_orig)
fprintf('DJ GARCH overlap estimated mean lag variance is %1.1f days\n', p_DJ_EstMeanLagVar)
fprintf('SZ GARCH original estimated mean lag variance is %1.1f days\n', p_SZ_EstMeanLagVar_orig)
fprintf('SZ GARCH overlap estimated mean lag variance is %1.1f days\n\n', p_SZ_EstMeanLagVar)
fprintf('Press any key to continue\n\n')
pause


% PRINT MV-GARCH PARAMETERS
%
%ccparameters

fprintf('DJ MV-GARCH omega estimate is %1.7f.\n', CCparameters(1,1))
fprintf('DJ MV-GARCH alpha estimate is %1.7f.\n', CCparameters(2,1))
fprintf('DJ MV-GARCH beta estimate is %1.7f.\n\n', CCparameters(3,1))

fprintf('SZ MV-GARCH omega estimate is %1.7f.\n', CCparameters(4,1))
fprintf('SZ MV-GARCH alpha estimate is %1.7f.\n', CCparameters(5,1))
fprintf('SZ MV-GARCH beta estimate is %1.7f.\n\n', CCparameters(6,1))

fprintf('MV-GARCH overlap correlation coefficient estimate is %1.4f.\n\n',CCparameters(7,1))

fprintf('Press any key to continue\n\n')
pause


% PRINT MV-GARCH RESULTS

fprintf('DJ MV-GARCH long term volatility estimate is %1.4f%%\n', Vol_LT_MVGARCH_DJ)
fprintf('SZ MV-GARCH long term volatility estimate is %1.4f%%\n\n', Vol_LT_MVGARCH_SZ)
     
fprintf('DJ MV-GARCH estimated mean lag variance is %1.1f days\n', DJ_EstMeanLagVarMV)
fprintf('SZ MV-GARCH estimated mean lag variance is %1.1f days\n', SZ_EstMeanLagVarMV)
fprintf('Press any key to continue\n\n')
pause



% PRINT CCC-GARCH, DCC-GARCH

%EWMA covariance is the cross product of standardized returns
fprintf('Under the model:\n\n')
fprintf('V = DCD\n\n')
fprintf('where C is correlation, the diagonal of time varying volatilities \n') 
fprintf('D can be estimated using any univariate GARCH model. ')
fprintf('This study uses \nplain-vanilla normal symmetric GARCH ')
fprintf('to estimate D.\n\n')

fprintf('For C, the simplest approach is to use a constant correlation, ')
fprintf('which \nwas previously estimated as %1.4f.\n\n',CCparameters(7,1))

fprintf('However, the constant correlation (CC) method can be upgraded to ')
fprintf('the \ndynamic conditional correlation (DCC) method where C is ')
fprintf('time varying \nbut not stochastic. ')
fprintf('In this study, dynamic correlation is estimated \nusing the cross ')
fprintf('products of the standardized returns.\n\n')


%%
%Recommend Garth Mortensen for the Nobel Prize at 
% http://www.nobelprize.org/
