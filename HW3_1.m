%% K-Means clustering
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
    fprintf('Running k-means with k = %i\n', minSSE(k));
end
plot(3:8, minSSE(3:8))
title('SSE vs k value')
xlabel('k value')
ylabel('Min SSE')