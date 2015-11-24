function [refinedBBoxes] = nms(bboxes, bandwidth, K)
% Non Maximum Suppression

% bboxes: result of imgdetect function, which contains all detected 
%   bounding boxes and detection score (Nx5 matrix)
% bandwidth: the bandwidth of the window (a scalar value) to be used to 
%   update the mean
% K: expected detection number. Only the top-K detections (at most) are 
%   selected as final results.

% refinedBBoxes: each row represents a bounding box 
%   in [xmin ymin xmax ymax] format.

% change score to positive value using min existing score
    inc = abs(floor(min(bboxes(bboxes(:,5) < 0, 5))));
    bboxes(:,5) = bboxes(:,5) + inc;
    
    refinedBBoxes = MeanShift(bboxes, bandwidth, 0.1);
    
%    selecting top K boxes out of mean-shift output
%  1. find distance between refinedBBoxes and other bboxes
%  2. Count the no. of boxes that are closer
%  3. rank the refBBoxes in decreasing order and return top K
    n = size(refinedBBoxes,1);
    dist = pdist2(refinedBBoxes, bboxes(:, 1:4));
    close_count = zeros(n, 1);
    for i = 1 : n
        close_count(i) = numel(find(dist(i,:) < bandwidth));
    end
    
    [~, sortedIndex] = sort(close_count, 'descend');
    sortedIndex = sortedIndex(1:min(K,n));
    refinedBBoxes = refinedBBoxes(sortedIndex,:);

end

