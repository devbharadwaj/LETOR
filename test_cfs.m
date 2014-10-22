clear all;
load('W_cfs','wMat');
load('project1_data','TESTS');


M = 20;
len_valid = length(TESTS);
val = 1;

for column = 2:M
    for row = 1:len_valid
        x_Mu = TESTS(row,2:end) - rand(1,46);
        vdMat(row,column) = exp((x_Mu * (eye(46).*rand) * x_Mu').*-1);
    end
    vdMat(:,1) = 1;
    for lambda = 0.01:0.01:0.1
        errw = 1/2 * sum((TESTS(:,1)- vdMat*wMat(1:column,:)).^2);
        err = errw + lambda/2 * sum(wMat.^2);
        GraphCFS_TESTS(val,:) = [column,lambda,sqrt(2*err/len_valid)];
        val = val + 1;
    end
end
save W_cfs.mat wMat
M_cfs = M - 7;
lambda_cfs = 0.01;
rms_cfs = min(GraphCFS_TESTS(:,3));
save CFS_Data.mat M_cfs lambda_cfs rms_cfs;
hold on;
title('Closed-Form Model Testing');
xlabel('Complexity (M)');
zlabel('Error (rms)');
ylabel('Lambda');
%plot3(GraphCFS_TESTS(:,1),GraphCFS_TESTS(:,2),GraphCFS_TESTS(:,3),'r')
legend('Closed-Form Solution');
hold off;
