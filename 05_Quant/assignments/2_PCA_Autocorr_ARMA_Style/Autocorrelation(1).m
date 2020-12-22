function [autocorrelations, chi_square]=Autocorrelation(series, max_lag, test_significance)

    a=size(series,2);
    n=size(series,1);
    autocorrelations=zeros(max_lag,a);
    chi_square=zeros(2,a);    
    for i=1:a;
        for j=1:max_lag
            y1 = series(1:(n-j),i);
            y2 = series(1+j:n,i);
            autocorrelations(j,i)=corr(y1,y2);
            chi_square(1,i)=chi_square(1,i)+n*(n+2)*autocorrelations(j,i)^2/(n-j);
        end
        chi_square(2,i)=chi2inv(1-test_significance, max_lag);
    end


end


