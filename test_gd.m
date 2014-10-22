clear all;
load('W_gd','wMat','eta');
load('project1_data','TESTS');

M = 20;

len_valid = length(TESTS);
wMat = wMat';
val = 1;

for column = 2:M 
    for row = 1:len_valid
        x_Mu = TESTS(row,2:end) - rand(1,46);
        vdMat(row,column) = exp((x_Mu * (eye(46).*(1/rand)) * x_Mu').*-1);
    end
    vdMat(:,1) = 1;
    errw = 1/2 * sum((TESTS(:,1)- vdMat*wMat(1:column,:)).^2);
    err = errw + 1/2 * sum(wMat.^2)+(1/column);
    GraphGD_TESTS(val,:) = [column,sqrt(2*err/len_valid)];
    val = val + 1;
end
hold on;
title('Stochastic Gradient Descent Testing');
xlabel('Complexity (M)');
ylabel('Error (rms)');
%plot(GraphGD_TESTS(:,1),GraphGD_TESTS(:,2),'r')
legend('Stochastic Gradient Descent');
hold off;

M_gd = 20;
eta_gd = eta;
rms_gd = min(GraphGD_TESTS(:,2));
save GD_Data.mat M_gd eta_gd rms_gd;
