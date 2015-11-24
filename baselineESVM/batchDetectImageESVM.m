function [boundingBoxes] = batchDetectImageESVM(imageNames, models, params)

    N = numel(imageNames);
    boundingBoxes = cell(1,N);
    
    parfor i = 1 : N
        I = imread(['../data/voc2007/', imageNames{i}]);
        boundingBoxes{i} = esvm_detect(I, models, params);
    end


end
