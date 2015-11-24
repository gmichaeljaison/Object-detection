function [CCenters,CMemberships] = MeanShift(data,bandwidth,stopThresh)
% data: N × (F + 1) matrix where N is the number of points and F is feature 
%   dimension. The final column means a score value at the feature 
%   location (the higher, the better)

% bandwidth: the bandwidth of the window (a scalar value) to be used to 
%   update the mean

% stopThresh: a scalar value used to check convergence of 
%   the Mean-Shift algorithm

% CCenters: M × F mode points (finally converged window centers), 
%   where M is the number of clusters

% CMemberships: N × 1 membership vector which shows the clustering result. 
%   Each value of element represents the corresponding mode index 
%   (row index of CCenters) for each data point

    w = data(:,end);
    data = data(:,1:end-1);
    
%     N = size(data,1);
%     F = size(data,2);
    
%   1. consider every point as seperate clusters and run mean-shift
%     algorithm
%   2. After convergence, the nearby points are real clusters

%       ? what will happen to outliers?


    CCenters = data;
    
    while (true)
        C = size(CCenters,1);
        dist = pdist2(CCenters, data);
        
        newCCenters = zeros(size(CCenters));
        for i = 1 : C
            closer_point_indices = find(dist(i,:) <= bandwidth);
            
            cdata = data(closer_point_indices, :);
            cw = w(closer_point_indices);
            
            newCCenters(i,:) = weighted_mean(cdata, cw);
        end
        
%         clf;
%         hold on;
%         scatter(data(:,1), data(:,2), 'b');
%         scatter(CCenters(:,1), CCenters(:,2), 1000, 'r');
%         hold off;
        
%         convergence check
        diff = abs(newCCenters - CCenters);
        if (sum(diff(:) / C) < stopThresh)
            break;
        end
        CCenters = newCCenters;
        
        pause(0.1);
        
    end
    
%   1. Among the clusters find the unique set of clusters that are closer
%   2. find mean of it

    dist = pdist2(CCenters, CCenters);
    C = size(CCenters,1);
    
    avgCC = zeros(size(CCenters));
    for i = 1 : C
        closer_p = CCenters(dist(i,:) <= bandwidth, :);
        avgCC(i,:) = mean(closer_p,1);
    end
    
    [CCenters,~,CMemberships] = unique(avgCC, 'rows');

end

function [mean] =  weighted_mean(data, w)
    F = size(data,2);
    data = data .* repmat(w, 1, F);
    
    mean = sum(data,1) / sum(w);
end
