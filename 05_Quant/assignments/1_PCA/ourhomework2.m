
clear all
close all
clc

load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_CAPITALIZATION')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_DATES')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_FLAGS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_IDENTIFIERS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_PRICES_Tprc')

% CAPITALIZATION(CAPITALIZATION == NaN) = 0
% %CAPITALIZATION(isnan(CAPITALIZATIONS))=0
% % % % where prices are negative or 0, we turn them into NaN
%   [I J] =find(CAPITALIZATION==NaN);
%    for k=1:length(I);
%        CAPITALIZATION(I(k),J(k))=0;
%    end
%    
%    clear I
% clear J
%  
% [I J] =find((PRICES)<=0);
%  
% for k=1:length(I);
%     PRICES(I(k),J(k))=NaN;
% end

 we need to get change NaN to 0
 weightP = sum(PRICES5')
 
 
 