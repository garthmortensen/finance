% Adapting the path and filename
filename = '\Session_2_Data.xlsm';

% Loading the raw data
X=xlsread(filename, 'PCA','B2:J84');

% Creating X demeaned
X_bar = X-repmat(mean(X),size(X,1),1);

% Running the PCA matlab tool
[Coeff_Matrix, PC_Matrix, Eigenvalues]=princomp(X_bar);

% testing...
[a, b]=eig(cov(X_bar)) % We have the Coeff_Matrix and the eigenvalues, but in ascending order!!!
Eigenvalues
Coeff_Matrix
var(PC_Matrix) % We have the eigenvalues, because they represent the variances of the PC's.
Coeff_Matrix'*Coeff_Matrix % This proves that the transpose is the inverse (the column vectors are orthonormal!!!
cov(PC_Matrix) % To show that the PC's have zero covariances.

% Writing the principal components in the worksheet
xlswrite(filename, PC_Matrix,'PCA','X2:AF84');

% Writing the eigenvalues in the worksheet
xlswrite(filename, Eigenvalues,'PCA','M14');