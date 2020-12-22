load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_CAPITALIZATION')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_DATES')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_FLAGS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_IDENTIFIERS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_PRICES_Tprc')
% 
% 
% % format our data, getting rid of headers
% CAPITALIZATION=CAPITALIZATION(2:end,2:end);
% DATES=PRICES(2:end,1);
% SRN=PRICES(1,2:end)
% PRICES=PRICES(2:end,2:end);
% FLAGS=FLAGS(2:end,2:end);    
% % below line not needed for us
% [T N]=size(PRICES)

% where prices are negative or 0, we turn them into NaN
[I J] =find(FLAGS==0);
 
for k=1:length(I);
    PRICES(I(k),J(k))=NaN;
end
 
clear I
clear J
 
[I J] =find((PRICES)<=0);
 
for k=1:length(I);
    PRICES(I(k),J(k))=NaN;
end
% in_window=1000
% out_window=1
% Parameters.in_window=in_window
% Parameters.out_window=out_window
% t0=in_window

% for t=t0:T-out_window        
%     Parameters.t=t;
    %[IDX,LPrices]=CreateLocalPricesReturns(PRICES,Parameters);
   
  LogPrices=log(PRICES);
  LogRet=diff(LogPrices);
    
  returns=exp(LogRet)
  [TL NL]=size(returns)
   
a= cov(returns)
a
b= corr(returns)

weight = sum(PRICES')