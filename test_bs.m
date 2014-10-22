clear all;
load('project1_data','TESTS');
load('bayesVAR');

M = 20;
len_valid = length(TESTS);
val = 1;

for column = 2:M
    for row = 1:len_valid
        x_Mu = TESTS(row,2:end) - rand(1,46);
        vdMat(row,column) = exp((x_Mu * (eye(46).*rand) * x_Mu').*-1);
    end
    vdMat(:,1) = 1;
    DMAT = vdMat'*vdMat;
    DMAT_TR = vdMat'*TESTS(:,1);
    
    A = alpha*eye(length(DMAT)) + beta*DMAT;
    Mn = beta*inv(A)*DMAT_TR;
    Emn = (beta/2)*sum((TESTS(:,1)-vdMat*Mn).^2) + (alpha/2)*(Mn'*Mn);
    conjugacy = (M/2)*log(alpha) + (len_valid/2)*log(beta) - Emn - 0.5*log(det(A))- (len_valid/2)*log(2*pi);
    GraphBS_TESTS(column-1,:) = [column,sqrt(2*Emn/len_valid)];
end
hold on;
title('Bayesian Model Testing');
xlabel('Complexity (M)');
ylabel('Error (rms)');
%plot(GraphBS_TESTS(:,1),GraphBS_TESTS(:,2),'r')
legend('Bayesian Regrtession');
rms_bs = min(GraphBS_TESTS(:,2));
save BS_Data.mat rms_bs;
hold off;
