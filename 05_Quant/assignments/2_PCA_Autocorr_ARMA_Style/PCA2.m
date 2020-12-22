% Adapting the path and filename
% filename = 'C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\assignment2\Session_2_DataREMAKE.xlsm';
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_CAPITALIZATION')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_DATES')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_FLAGS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_IDENTIFIERS')
load('C:\Users\garth\Desktop\EDHEC Everything\EDHEC classes\quant\SP500_2007_2009_PRICES_Tprc')


% where prices are negative or 0, we turn them into NaN
% [I J] =find(FLAGS==0); 
% for k=1:length(I);
%     PRICES5(I(k),J(k))=NaN;
% end 
% clear I
% clear J
% 
% [I J] =find((PRICES5)<=0);
% for k=1:length(I);
%     PRICESS(I(k),J(k))=NaN;
% end

%filtering
% here we find where all nan is, and set to 1.
% I = isnan(PRICES5);
% IDX = sum(I);
% IR = find(IDX==0);
% Y=PRICES5(:,IR);

%clean the matrix
I = sum(FLAGS);
IR = find(I==756);
Y=PRICES5(:,IR);
C=CAPITALIZATION(:,IR);

LogPrices=log(Y);
LogRet=diff(LogPrices);

cov1=cov(LogRet);
corr1= corr(LogRet);
%and part 1 is done!

%Start of part 2
%this is redundant. we repeat this in the princomp line. Wait, for part 3
%we want eigenvectors...

% Creating X demeaned
X_bar = LogRet-repmat(mean(LogRet),size(LogRet,1),1);

% Running the PCA matlab tool
[Coeff_Matrix, PC_Matrix, Eigenvalues]=princomp(X_bar);

[v d] = eig(cov1); 

% now we want to represent our returns as a linear combination of the
% PC coefficients. 
vinv=inv(v)
CoefRegression=Coeff_Matrix*vinv

 % % testing...
% [a, b]=eig(cov(X_bar)); % We have the Coeff_Matrix and the eigenvalues, but in ascending order!!!
% Eigenvalues;
% Coeff_Matrix;
% var(PC_Matrix); % We have the eigenvalues, because they represent the variances of the PC's.
% Coeff_Matrix'*Coeff_Matrix; % This proves that the transpose is the inverse (the column vectors are orthonormal!!!
% cov(PC_Matrix); % To show that the PC's have zero covariances.
% 
% % Writing the principal components in the worksheet
% % xlswrite(filename, PC_Matrix,'PCA','X2:AF84');
% 
% % Writing the eigenvalues in the worksheet
% %xlswrite(filename, Eigenvalues,'PCA','M14');
% 
% 
% 
