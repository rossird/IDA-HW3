clear all; clc;

% Load data. Only read first 50 entries.
% Exclude first column, it is student number.
Data = xlsread('StudentData2.xlsx','B2:E51');

startK = 3;
endK = 8;
kmeansIter = 3;

% Run k-means for values 3 through 8
for k = startK : endK
    % For each k-means, run three times and choose the clustering with the
    % smallest SSE value.
    for c = 1:kmeansIter
        fprintf('Running k-means with k = %i\n',k);
        temp = randperm(50);
        seeds = temp(1:k);
        
        % K-means by default uses Squared Euclidean distance.
        [clusterID, centroids, SUMD, D] = kmeans(Data, k, 'Start', Data(seeds,:));
        
        % Find SSE
        SSE = 0;
        for i = 1:50
           cluster = clusterID(i);
           SSE = SSE + D(i, cluster); 
        end
        fprintf('SSE: %0.4f\n',SSE);
    end
end