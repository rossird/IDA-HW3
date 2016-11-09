% Compare Clustering-1 and Clustering-2
clear; clc;

load Clustering-1
load Clustering-2

% Calculate rand index
a = 0;
b = 0;
c = 0;
d = 0;
for i = 1:length(labels1)
    for j = i+1:length(labels1)
        % Are elements i,j in same set in clustering 1?
        p1 = labels1(i) == labels1(j);
        
        % What set is pair i,j in clustering3?
        p2 = labels2(i) == labels2(j);
        
        if p1 && p2
            % They in the same set in both clusterings
            a = a + 1;
        elseif ~p1 && ~p2
            % They are in different sets in both clusterings
            b = b + 1;
        elseif p1 && ~p2
            % They are in the same set clustering2, diff sets clustering3
            c = c + 1;
        else
            % They are in diff set clustering2, same sets clustering3
            d = d + 1;
        end
    end
end
randIndex = (a + b)/(a + b + c + d);

fprintf('\n')
fprintf('Comparing Clustering-1 to Clustering-2\n')
fprintf('a = %i\n',a);
fprintf('b = %i\n',b);
fprintf('c = %i\n',c);
fprintf('d = %i\n',d);
fprintf('Rand Index: %0.4f\n',randIndex);