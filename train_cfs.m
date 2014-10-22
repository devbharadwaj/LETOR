clear all;
load('project1_data','TRAIN','VALID');

% TRAINING CODE 

len_train = length(TRAIN);
M = 20;

value = 1;

for column = 2:M
    for row = 1:len_train
        x_Mu = TRAIN(row,2:end) - rand(1,46);
        dMat(row,column) = exp((x_Mu * (eye(46).*rand) * x_Mu').*-1);
    end
    dMat(:,1) = 1; 
    wMat1 = inv(dMat'*dMat);
    wMat2 = dMat'*TRAIN(:,1);
    wMat = wMat1 * wMat2;

    for lambda = 0.01:0.01:0.1
        errw = 1/2 * sum((TRAIN(:,1)- dMat*wMat).^2);
        err = errw + lambda/2 * sum(wMat.^2);
        GraphCFS(value,:) = [column,lambda,sqrt(2*err/len_train)];
        value = value + 1;
   end
end

save W_cfs.mat wMat;
save dMat.mat dMat;
%GraphCFS
%save graph_cfs.mat GraphCFS
hold on;
title('Closed-Form Model Validation');
xlabel('Complexity (M)');
ylabel('Lambda');
zlabel('Error (rms)');
% plot3(GraphCFS(:,1),GraphCFS(:,2),GraphCFS(:,3))


% VALIDATION CODE 

len_valid = length(VALID);
val = 1;
for column = 2:M
    for row = 1:len_valid
        x_Mu = VALID(row,2:end) - rand(1,46);
        vdMat(row,column) = exp((x_Mu * (eye(46).*rand) * x_Mu').*-1);
    end
    vdMat(:,1) = 1;
    for lambda = 0.01:0.01:0.1
        errw = 1/2 * sum((VALID(:,1)- vdMat*wMat(1:column,:)).^2);
        err = errw + lambda/2 * sum(wMat.^2);
        GraphCFS_VALID(val,:) = [column,lambda,sqrt(2*err/len_valid)];
        val = val + 1;
    end
end


%plot3(GraphCFS_VALID(:,1),GraphCFS_VALID(:,2),GraphCFS_VALID(:,3),'g')
legend('Closed-Form Solution');
hold off;
