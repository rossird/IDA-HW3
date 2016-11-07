%% Hierchical Clustering
clear all; close all; clc;

Data = xlsread('StudentData2.xlsx','B2:E51');

numClusters = 4;

% Perform clustering
dist = pdist(Data);
clustering2 = linkage(dist, 'single');
clustering3 = linkage(dist, 'complete');

% Display dendrograms
figure
dendrogram(clustering2);
title('Hierarchical clustering (Single-link)')

figure
dendrogram(clustering3);
title('Hierarchical clustering (Complete-link)')

% Create 4 clusters
labels2 = cluster(clustering2, 'maxclust', numClusters);
labels3 = cluster(clustering3, 'maxclust', numClusters);

% Calculate centroids
clusters2 = cell(numClusters);
centroids2 = zeros(numClusters,4);
clusters3 = cell(numClusters);
centroids3 = zeros(numClusters,4);
for i = 1:numClusters
   clusters2{i} = Data(labels2 == i,:);
   centroids2(i,:) = sum(clusters2{i}) / length(find(labels2 == i));
   
   clusters3{i} = Data(labels3 == i,:);
   centroids3(i,:) = sum(clusters3{i}) / length(find(labels3 == i));
end

% Print the clusters
fprintf('-- Clustering-2 --\n')
for i = 1:numClusters
    curCluster = clusters2{i};
    [numRows numCols] = size(curCluster);
    fprintf('Cluster #%i - %i points\n',i,numRows);
    for row = 1:numRows
        point = curCluster(row,:);
        fprintf('Point %i:\t',row);
        for dim = 1:length(point)
            fprintf('%i\t',point(dim));
        end
        fprintf('\n');
    end
end
fprintf('\n\n');
fprintf('-- Clustering-3 --\n')
for i = 1:numClusters
    curCluster = clusters3{i};
    [numRows numCols] = size(curCluster);
    fprintf('Cluster #%i - %i points\n',i,numRows);
    for row = 1:numRows
        point = curCluster(row,:);
        fprintf('Point %i:\t',row);
        for dim = 1:length(point)
            fprintf('%i\t',point(dim));
        end
        fprintf('\n');
    end
end

% Create contingency table for rand index
a = 0;
b = 0;
c = 0;
d = 0;
for i = 1:length(labels2)
    for j = i:length(labels2)
        % Are elements i,j in same set in clustering 1?
        p2 = labels2(i) == labels2(j);
        
        % What set is pair i,j in clustering3?
        p3 = labels3(i) == labels3(j);
        
        if p2 && p3
            % They in the same set in both clusterings
            a = a + 1;
        elseif ~p2 && ~p3
            % They are in different sets in both clusterings
            b = b + 1;
        elseif p2 && ~p3
            % They are in the same set clustering2, diff sets clustering3
            c = c + 1;
        elseif ~p2 && p3
            % They are in diff set clustering2, same sets clustering3
            d = d + 1;
        end
    end
end
randIndex = (a + b)/(a + b + c + d);

fprintf('\n')
fprintf('Comparing Clustering-2 to Clustering-3\n')
fprintf('a = %i\n',a);
fprintf('b = %i\n',b);
fprintf('c = %i\n',c);
fprintf('d = %i\n',d);
fprintf('Rand Index: %0.4f\n',randIndex);

save('Clustering-2', 'clustering2','clusters2','labels2','centroids2');
