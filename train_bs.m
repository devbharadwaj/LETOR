clear all;
load('project1_data','TRAIN');

MeanVector = mean(TRAIN(:,2:end));
StdVector = std(TRAIN(:,2:end));

alpha_o = 1000;
beta_o = 1000;
alpha = rand();
beta = rand();
len_train = length(TRAIN);
margin = 0.0001;
iter = 0;
M = 20;

for column = 2:M
    for row = 1:len_train
        x_Mu = TRAIN(row,2:end) - MeanVector(column-1);
        dMat(row,column) = exp((x_Mu * (eye(46).*StdVector(column-1)) * x_Mu').*-1);
    end
    dMat(:,1) = 1;
    DMAT = dMat'*dMat;
    DMAT_TR = dMat'*TRAIN(:,1);
    for avger = 1:20
        while abs(alpha_o - alpha) > margin && abs(beta_o - beta) > margin
            alpha_o = alpha;
            beta_o = beta;
            iter = iter + 1;
            A = alpha*eye(length(DMAT)) + beta*DMAT;
            Mn = beta*inv(A)*DMAT_TR;
            lambda = eig(beta*DMAT);
            gamma = sum(lambda)/sum(alpha+lambda);
            randN = rand();
            alpha = gamma*((Mn'*Mn).^-1) +randN;
            beta = 1/(len_train-gamma)* sum(TRAIN(:,1)-dMat*Mn)+randN;
        end
        alphaV(avger) = alpha;
        betaV(avger) = beta;
    end
    alpha = mean(alphaV);
    beta = mean(beta);
    A = alpha*eye(length(DMAT)) + beta*DMAT;
    Mn = beta*inv(A)*DMAT_TR;
    Emn = (beta/2)*sum((TRAIN(:,1)-dMat*Mn).^2) + (alpha/2)*(Mn'*Mn);
    conjugacy = (M/2)*log(alpha) + (len_train/2)*log(beta) - Emn - 0.5*log(det(A))- (len_train/2)*log(2*pi);
    Graph_BS(column-1,:) = [column,sqrt(2*Emn/len_train)];
end
hold on;
title('Bayesian Model Training');
xlabel('Complexity (M)');
ylabel('Error (rms)');
%plot(Graph_BS(:,1),Graph_BS(:,2))
legend('Bayesian Regression');
hold off;
save bayesVAR.mat alpha beta;
