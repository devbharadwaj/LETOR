clear all;

% Run all the models on the data

train_cfs;
test_cfs;
train_gd;
test_gd;
train_bs;
test_bs;
load('CFS_Data');
load('GD_Data');
load('BS_Data');

myubitname = 'dbharadw';
mynumber = 50096815;

fprintf('My ubit name is %s\n',myubitname);
fprintf('My student number is %d \n',mynumber);
fprintf('the model complexity M_cfs is %d\n', M_cfs);
fprintf('the model complexity M_gd is %d\n', M_gd);
fprintf('the regularization parameters lambda_cfs is %4.2f\n', lambda_cfs);
fprintf('the regularization parameters eta_gd is %4.9f\n', eta_gd);
fprintf('the root mean square error for the closed form solution is %4.2f\n', rms_cfs);
fprintf('the root mean square error for the gradient descent method is %4.2f\n', rms_gd);
fprintf('the root mean square error for the Bayesian solution is %4.2f\n', rms_bs);
