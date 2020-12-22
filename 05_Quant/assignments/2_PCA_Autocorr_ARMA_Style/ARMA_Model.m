%Loading the time series:
y=xlsread('x\Session_3_Data_Final.xlsx','AR(1)','B2:B169');

%Running the AR(1) model estimation to confirm the results given by the linear regression:
parameters=armaxfilter(y,1,1)

% An AR(p) model is estimated with armaxfilter(y,1,[1:p]). The first
% argument is the time series and the second one is 1 or 0 to indicate
% whether a constant should be included or not in the model. The model
% armaxfilter(y,1,[1 p]) means only having the lags 1 and p...

%Running the MA(1) model estimation:
parameters=armaxfilter(y,1,[],1)

% An MA(q) model is estimated with armaxfilter(y,1,[],[1:q]).

%Running the ARMA(1,1) model estimation:
parameters=armaxfilter(y,1,1,1)

% An ARMA(p,q) model is estimated with parameters = armaxfilter(y,1,1:P,1:Q).

%Running the ARMA(1,1) model estimation and calculating the errors:
[parameters, errors]=armaxfilter(y,1,1,1);

%Confirming the model equation
err = y(2:168)-parameters(1)-parameters(2)*y(1:167)-parameters(3)*errors(1:167);
errors(2:168)-err

% Calculating the RMSE
RMSE = sqrt(mean(errors.^2));