function [filterResponses] = extractFilterResponses(I, filterBank)
% CV Fall 2015 - Provided Code
% Extract the filter responses given the image and filter bank
% Pleae make sure the output format is unchanged. 
% Inputs: 
%   I:                  a 3-channel RGB image with width W and height H 
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses
 
% if the image is greyscale, repeat same values for RGB. I: h x w x 3
if (size(I,3) == 1)
    I = repmat(I, [1,1,3]);
end

%Convert input Image to Lab
doubleI = double(I);
[L,a,b] = RGB2Lab(doubleI(:,:,1), doubleI(:,:,2), doubleI(:,:,3));
pixelCount = size(doubleI,1)*size(doubleI,2);

%filterResponses:    a W*H x N*3 matrix of filter responses
filterResponses = zeros(pixelCount, length(filterBank)*3);

%for each filter and channel, apply the filter, and vectorize

% === fill in your implementation here  ===

for index = 1 : numel(filterBank)
    
    filteredL = imfilter(L, filterBank{index}, 'same');
    filteredA = imfilter(a, filterBank{index}, 'same');
    filteredB = imfilter(b, filterBank{index}, 'same');
    
    respIndex = (index-1) * 3;

    filterResponses(:, respIndex + 1) = reshape(filteredL, [], 1);
    filterResponses(:, respIndex + 2) = reshape(filteredA, [], 1);
    filterResponses(:, respIndex + 3) = reshape(filteredB, [], 1);
end
