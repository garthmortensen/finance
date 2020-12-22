CAPITALIZATIONa=CAPITALIZATION(2:end,2:end);
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
 


