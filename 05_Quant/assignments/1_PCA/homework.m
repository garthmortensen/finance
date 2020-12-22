clear all
close all
clc
 
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_CAPITALIZATION')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_DATES')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_FLAGS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_IDENTIFIERS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_PRICES_Tprc')

CAPITALIZATION=CAPITALIZATION(2:end,2:end);
DATES=PRICES(2:end,1);
SRN=PRICES(1,2:end);
PRICES=PRICES(2:end,2:end);
FLAGS=FLAGS(2:end,2:end);    
[T N]=size(PRICES)
 
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

