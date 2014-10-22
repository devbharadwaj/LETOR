clear all;
load('project1_data','TRAIN','VALID');
load('W_reg');

% TRAINING CODE

len_train = length(TRAIN);

M = 20;

for column = 2:M 
    for row = 1:len_train
        x_Mu = TRAIN(row,2:end) - rand(1,46);
        dMat(row,column) = exp((x_Mu * (eye(46).*(1/rand)) * x_Mu').*-1);
    end
    dMat(:,1) = 1;
    wMat = rand(1,column);
    
    olderr = 100000;
    errDiff = 1;
    eta = 1;
    offset = 1;
    errSet = 20000;
    iter = 1;
    while errDiff > 0.0001 && eta > 0
        randrow = randi([1 len_train],1);
        wMat1 = wMat + ((TRAIN(randrow,1)- (wMat'*dMat(randrow,:))*dMat(randrow,:)').*eta)'; 
        if offset + errSet > len_train
            offset = 1;
        end
        errw = 1/2 * sum((TRAIN(offset:offset+errSet,1)- dMat(offset:offset+errSet,:)*wMat1').^2); 
        err = sqrt(2*(errw/errSet))+ln(column-1);
        errDiff = abs(olderr - err);
        if err > olderr
            eta = eta * (1/iter);
        end
        olderr = err;
        wMat = wMat1;
        iter = iter + 1;
        offset = offset + errSet;
    end
    GraphGD(column-1,:) = [column-1,err];
end
eta = 1/(iter^3);
save W_gd.mat wMat eta
hold on;
title('Stochastic Gradient Descent Training');
xlabel('Complexity (M)');
ylabel('Error (rms)');
%plot(GraphGD(:,1),GraphGD(:,2))

% VALIDATION CODE

len_valid = length(VALID);
wMat = wMat';
val = 1;
for column = 2:M 
    for row = 1:len_valid
        x_Mu = VALID(row,2:end) - rand(1,46);
        vdMat(row,column) = exp((x_Mu * (eye(46).*(1/rand)) * x_Mu').*-1);
    end
    vdMat(:,1) = 1;
    errw = 1/2 * sum((VALID(:,1)- vdMat*wMat(1:column,:)).^2);
    err = errw + 1/2 * sum(wMat.^2)+(1/column);
    GraphGD_VALID(val,:) = [column,sqrt(2*err/len_valid)];
    val = val + 1;
end

%plot(GraphGD_VALID(:,1),GraphGD_VALID(:,2),'g')
legend('Stochastic Gradient Descent');
hold off;
