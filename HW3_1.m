% K-Means clustering
clear all; clc; close all;

% We will be using the Squared Euclidean method for determining distance
% between two points.

% Load data. Only read first 50 entries.
% Exclude first column, it is student number.
Data = xlsread('StudentData2.xlsx','B2:E51');

startK = 3;
endK = 8;
kmeansIter = 3;

% Init minimum SSE for each value of k
minSSE = ones(endK,1) * 10^10;
clustering = cell(8,2);

% Run k-means for values 3 through 8
for k = startK : endK
    fprintf('Running k-means with k = %i\n',k);
    % For each k-means, run three times and choose the clustering with the
    % smallest SSE value.
    for c = 1:kmeansIter
        temp = randperm(50);
        seeds = temp(1:k);
        
        % K-means by default uses Squared Euclidean distance.
        [clusterID, centroids, ~, pointClusterDistance] = kmeans(Data, k, 'Start', Data(seeds,:));
        
        % Find SSE
        SSE = 0;
        for i = 1:50
           cluster = clusterID(i);
           SSE = SSE + pointClusterDistance(i, cluster).^2; 
        end
        if SSE < minSSE(k)
           minSSE(k) = SSE;
           clustering{k} = {centroids clusterID};
        end
    end
    fprintf('SSE = %0.2f\n', minSSE(k));
    subplot(3,2, k - startK + 1);
    silhouette(Data, clustering{k}{2});
end

figure
plot(3:8, minSSE(3:8))
title('SSE vs k value')
xlabel('k value')
ylabel('Min SSE')

% Select the best clustering
choice = input('Please enter the best clustering (3-8): ');
while choice < 3 || choice > 8
    fprintf('Invalid entry\n');
    choice = input('Please enter the best clustering (3-8): ');
end
labels1 = clustering{choice}{2};
centroids1 = clustering{choice}{1};
for i = 1:choice
   clusters1{i} =  Data(labels1 == i,:);
end

% Print the centroids
fprintf('Centroids for selected clustering:\n');
for i = 1:choice
    fprintf('Centroid %i',i)
    disp(centroids1(i,:));
end
save('Clustering-1','clusters1','labels1','centroids1');

% Compare to random data
randomData = randi([0 100],[50 4]);
temp = randperm(50);
seeds = temp(1:choice);
[clusterID, centroids, ~, pointClusterDistance] = kmeans(randomData, choice, 'Start', randomData(seeds,:));

% Find SSE
SSE = 0;
for i = 1:50
   cluster = clusterID(i);
   SSE = SSE + pointClusterDistance(i, cluster).^2; 
end
fprintf('SSE value for random data: %0.2f\n',SSE);
fprintf('Centroids for random data:\n')
for i = 1:choice
    fprintf('Centroid %i',i)
    disp(centroids(i,:));
end
fprintf('Populations for clusters:\n')
for i = 1:choice
   fprintf('Cluster %i: %i\n',i,sum(clusterID == i)); 
end
hold on; plot(choice, SSE, 'r*');
legend('Student Data','Random Data');
