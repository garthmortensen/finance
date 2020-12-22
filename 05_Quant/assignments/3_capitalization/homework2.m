
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\matlabdata\SP500_10Y_SERIES')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\matlabdata\SP500_10Y_FLAGS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\matlabdata\DATES_SP500_10Y')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\matlabdata\SP500_10Y_CAPITALIZATION')

% format our data, getting rid of headers
CAPITALIZATION=CAPITALIZATION(2:end,2:end);
DATES=PRICES(2:end,1);
SRN=PRICES(1,2:end)
PRICES=PRICES(2:end,2:end);
FLAGS=FLAGS(2:end,2:end);    
% below line not needed for us
[T N]=size(PRICES);

% in_window=1000
% out_window=1
% Parameters.in_window=in_window
% Parameters.out_window=out_window
% t0=in_window

% for t=t0:T-out_window        
%     Parameters.t=t;
    %[IDX,LPrices]=CreateLocalPricesReturns(PRICES,Parameters);
   

weightP = sum(PRICES')';
weightC = sum(CAPITALIZATION')';

wc = CAPITALIZATION./weightC