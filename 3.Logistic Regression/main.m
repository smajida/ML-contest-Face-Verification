clear;
%load('small_feature');
load('train_data');
load('/Users/cmy/Documents/Machine_Learning/contest/0.Data_sets/trainSet_deep_PCA99');
load('/Users/cmy/Documents/Machine_Learning/contest/0.Data_sets/testSet_deep_PCA99');
load('pairs');
%X = small_feature;
X = trainSet_deep_PCA99;
[m, n] = size(X);
X = [ones(m, 1) X];
lambda = 1;
% Initialize fitting parameters
for i=1:271
    fprintf('Training parameters of class%d\n',i);
    Y = zeros(size(training_label));
    Y(find(training_label==i),:) = 1;
    initial_theta = zeros(n + 1, 1);
    options = optimset('GradObj', 'on', 'MaxIter', 250);
    %[theta(:,i), cost] = fminunc(@(t)(costFunction(t, X, Y)), initial_theta, options);
    %[cost, grad] = costFunction(initial_theta, X, Y);
    [theta(:,i), cost] = fmincg(@(t)(costFunction(t, X, Y)), initial_theta, options);
end

%calculate the accuracy with training set
[~,T] = max(sigmoid(X*theta),[],2);
fprintf('Train Accuracy: %f\n', mean(double(T == training_label)) * 100);

testSet = [ones(size(testSet_deep_PCA99,1),1),testSet_deep_PCA99];
testSet_prossibility = sigmoid(testSet*theta);
B = testSet*theta;

for i=1:size(B,1)
    m = min(B(i,:));
    if m < 0
        B(i,:) = B(i,:)-m;
    end
end

[possible,tmp,result] = get_by_possibility(pairs,B);
%dlmwrite('LR_result1.csv',result,'precision',15);

