% Adapting the path and filename
filename = '\Session_2_Data.xlsm';

% Loading the data
Returns = xlsread(filename, 'Style_Analysis','B3:D3394');
Factors = xlsread(filename, 'Style_Analysis','E3:P3394');

% Running the regressions (without intercept!)
a = size(Returns,2);
k = size(Factors,2);
Coefficients = zeros(k,a);
Aeq = ones(1,k);
adjRsquare = zeros(1,a);
    
for i = 1:a;

    Y = Returns(:,i);
    Coefficients(:,i) = lsqlin(Factors,Y,[],[],Aeq,1,0*Aeq,1*Aeq);
    R = corr(Y,Factors*Coefficients(:,i));
    adjRsquare(1,i)=1-(1-R^2)*(size(Y,1)-1)/(size(Y,1)-k); % Attention because here we do not have 
                                                           % intercept, such that the adjRsquare formula
                                                           % should be divided by (n-k) instead of 
                                                           % (n-k-1) - but the difference is minimal!
end

clear i a b Aeq Y R k

% Writing the results in the worksheet
xlswrite(filename, Coefficients,'Style_Analysis','S4:U15');
xlswrite(filename, adjRsquare,'Style_Analysis','S16:U16');

clear filename 
